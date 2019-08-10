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
  has_many :report_parts, through: :contracts
  has_many :reports, through: :report_parts
  has_many :users, through: :reports
  has_many :reporting_periods, through: :reports
  accepts_nested_attributes_for :contracts, allow_destroy: true
end
