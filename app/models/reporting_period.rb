# == Schema Information
#
# Table name: reporting_periods
#
#  id         :bigint           not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ReportingPeriod < ApplicationRecord
  has_many :reports
  has_many :report_parts, through: :reports
  has_many :full_reports

  def display_name
    date.strftime("%B %Y")
  end

  def total_contracts_reported
    full_reports.select(:contract_id).distinct.count
  end

  def total_time_reported
    full_reports.sum(:days)
  end

  def contracts_mean_variance_and_stdev filters
    contracts = self.full_reports.
      contracts_distribution(filters).first.contracts

    mean = contracts.inject{ |sum, el| sum + el }.to_f / contracts.size

    step = contracts.inject(0){|accum, i| accum+(i-mean)**2}
    variance = contracts.size > 1 ? step/(contracts.size-1).to_f : nil

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
    teams = Team.where(name: ['K', 'Rosling']).order(:name)
    ReportingPeriod.order(:date).each do |rp|
      next unless rp.full_reports.any?
      data = { rp: rp }
      teams.each do |t|
        filters_with_team = filters.merge({team_id: t.id})
        metrics = {}
        metrics[:total_contracts] = rp.full_reports.
          filtered(filters_with_team).select(:contract_id).
          distinct.count

        metrics[:total_reporters] = rp.full_reports.
          filtered(filters_with_team).select(:user_id).
          distinct.count

        metrics.merge!(rp.contracts_mean_variance_and_stdev(filters_with_team))

        data[t.name.to_sym] = metrics
      end
      result << data
    end
    result
  end
end
