class Project < ApplicationRecord
  has_many :users, through: :reports
  belongs_to :team, optional: true
  has_many :contracts, dependent: :destroy
  has_many :report_parts, through: :contracts
  has_many :reports, through: :report_parts
  has_many :reporting_periods, through: :reports
  accepts_nested_attributes_for :contracts, allow_destroy: true
end
