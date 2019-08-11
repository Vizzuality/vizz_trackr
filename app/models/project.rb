# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string
#  budget     :float
#  start_date :date
#  end_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#

class Project < ApplicationRecord
  belongs_to :team, optional: true
  has_many :contracts, dependent: :destroy
  accepts_nested_attributes_for :contracts, allow_destroy: true

  has_many :full_reports, through: :contracts
  has_many :report_parts, through: :contracts
  has_many :reports, through: :report_parts
  has_many :users, through: :reports
  has_many :reporting_periods, through: :reports

  has_many :project_finances

  validates_uniqueness_of :name

  def budget
    contracts.try(:sum, :budget)
  end

  def spend
    full_reports.try(:sum, :cost).presence || 0.0
  end
end
