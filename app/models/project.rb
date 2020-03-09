# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#  is_billable :boolean          default(TRUE)
#

class Project < ApplicationRecord
  belongs_to :team, optional: true
  has_many :contracts

  has_many :full_reports, through: :contracts
  has_many :report_parts, through: :contracts
  has_many :reports, through: :report_parts
  has_many :users, through: :reports
  has_many :reporting_periods, through: :reports

  has_many :project_links
  accepts_nested_attributes_for :project_links,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['title'].blank? || attributes['url'].blank? }

  validates_uniqueness_of :name
  validates_presence_of :name

  def budget
    contracts.try(:sum, :budget)
  end

  def costs
    contracts.map(&:total_burn).compact.reduce(:+)
  end

  def burn_percentage
    (costs / budget * 100).round(2)
  end
end
