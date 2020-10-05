# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  is_billable :boolean          default(TRUE)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_projects_on_name     (name) UNIQUE
#  index_projects_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#

class Project < ApplicationRecord
  belongs_to :team, optional: true
  has_many :contracts, dependent: :restrict_with_error

  has_many :full_reports, through: :contracts
  has_many :report_parts, through: :contracts
  has_many :reports, through: :report_parts
  has_many :users, through: :reports
  has_many :reporting_periods, through: :reports

  has_many :project_links, dependent: :restrict_with_error
  accepts_nested_attributes_for :project_links,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['title'].blank? || attributes['url'].blank? }

  validates :name, uniqueness: true, presence: true

  def budget
    contracts.try(:sum, :budget)
  end

  def costs
    contracts.map(&:total_burn).compact.reduce(:+)
  end

  def burn_percentage
    (costs / budget * 100).round(2)
  end

  def self.search query
    return all unless query

    where('name ilike ?', "%#{query}%")
  end
end
