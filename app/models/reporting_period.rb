# == Schema Information
#
# Table name: reporting_periods
#
#  id         :bigint           not null, primary key
#  aasm_state :string
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reporting_periods_on_date  (date) UNIQUE
#
require 'csv'

class ReportingPeriod < ApplicationRecord
  paginates_per 10

  include AASM
  include HasStateMachine

  aasm do
    state :unstarted, initial: true
    state :active, before_enter: proc { ReportingPeriod.deactivate_active_reporting! }
    state :finished
    event :start do
    end
    event :activate do
      transitions from: :unstarted, to: :active
    end
    event :terminate do
      transitions from: :active, to: :finished
    end
    event :reactivate do
      transitions from: :finished, to: :active
    end
  end

  def self.deactivate_active_reporting!
    ReportingPeriod.where(aasm_state: 'active').find_each(&:terminate!)
  end

  has_many :reports, dependent: :destroy
  has_many :report_parts, through: :reports
  has_many :contracts, through: :report_parts
  has_many :users, through: :reports
  has_many :full_reports, dependent: :restrict_with_error
  has_many :non_staff_costs, dependent: :destroy

  validates :date, uniqueness: true

  def self.active_period
    ReportingPeriod.find_by(aasm_state: 'active')
  end

  def display_name
    date.strftime('%B %Y')
  end

  def total_contracts_reported
    full_reports.select(:contract_id).distinct.count
  end

  def total_time_reported
    full_reports.sum(:days)
  end

  # copy just the projects, without assigned percentages
  def copy_reports_from source
    source.reports.each do |report|
      next unless report.user.active?

      dupped = report.dup
      dupped.estimated = true
      report.report_parts.each do |part|
        next if part.contract.finished?

        dupped.report_parts << ReportPart.new(contract_id: part.contract_id,
                                              role_id: part.role_id)
      end
      reports << dupped
    end
  end

  def announcement
    msg = <<-EOS
      @here Hello!
      #{date.strftime('%B')}'s report is ready to be filled in! Please go to https://vizz-trackr.herokuapp.com/my-report to do it.
      If you don't have a password yet, please use the Forgot your Password feature with your Vizzuality email. :simple_smile:.
      Thank you!
    EOS
    {
      channel: Rails.env.production? ? '#announcements' : '#vizz-tracker',
      text: msg,
      icon_emoji: ':vizzuality:',
      parse: 'full'
    }.to_json
  end

  def to_csv
    content = users_as_rows
    CSV.generate(headers: true, encoding: 'ISO-8859-1') do |csv|
      csv << content.first.keys
      content.each do |c|
        csv << c.values
      end
    end
  end

  def users_as_rows
    content = []
    users.order(:name).each do |user|
      data = {}
      data['staff'] = user.name
      report = reports.find_by(user_id: user.id)
      Contract.where(id: report_parts.map(&:contract_id).uniq)
        .includes(:project).order(:name).each do |contract|
        percentage = report.report_parts
          .where(contract_id: contract.id)
          .sum(:percentage) || 0
        data[contract.full_name] = percentage && (percentage / 100).round(2)
      end
      data['estimated'] = report.estimated?
      content << data
    end
    content
  end

  def contracts_mean_variance_and_stdev filters
    contracts = full_reports
      .contracts_distribution(filters).first.try(:contracts)

    return {} unless contracts

    mean = contracts.inject { |sum, el| sum + el }.to_f / contracts.size

    step = contracts.inject(0) { |accum, i| accum + (i - mean)**2 }
    variance = contracts.size > 1 ? step / (contracts.size - 1).to_f : nil

    stdev = variance ? Math.sqrt(variance).try(:round, 2) : nil

    {
      contracts: contracts,
      mean: mean.round(2),
      variance: variance.try(:round, 2),
      stdev: stdev.try(:round, 2)
    }
  end

  def self.analyse filters
    result = []
    teams = Team.where(name: %w[K Rosling]).order(:name)

    ReportingPeriod.order(:date).each do |rp|
      next unless rp.full_reports.any?

      data = {rp: rp}
      teams.each do |t|
        filters_with_team = filters.merge(team_id: t.id)
        metrics = {}
        metrics[:total_contracts] = rp.full_reports
          .filtered(filters_with_team).select(:contract_id)
          .distinct.count

        metrics[:total_reporters] = rp.full_reports
          .filtered(filters_with_team).select(:user_id)
          .distinct.count

        metrics.merge!(rp.contracts_mean_variance_and_stdev(filters_with_team))

        data[t.name.to_sym] = metrics
      end
      result << data
    end
    result
  end
end
