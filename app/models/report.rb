# == Schema Information
#
# Table name: reports
#
#  id                  :bigint           not null, primary key
#  estimated           :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  reporting_period_id :bigint           not null
#  team_id             :integer
#  user_id             :bigint           not null
#
# Indexes
#
#  index_reports_on_reporting_period_id  (reporting_period_id)
#  index_reports_on_team_id              (team_id)
#  index_reports_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (reporting_period_id => reporting_periods.id)
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#

class Report < ApplicationRecord
  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :reporting_period
  has_many :report_parts, dependent: :destroy
  accepts_nested_attributes_for :report_parts, allow_destroy: true

  has_many :contracts, through: :report_parts

  def rate
    reporting_period.base_rate
  end
end
