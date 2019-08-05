class Project < ApplicationRecord
  has_many :report_parts, dependent: :destroy
  has_many :reports, through: :report_parts, dependent: :destroy
  has_many :reporting_periods, through: :reports
  has_many :users, through: :reports
  belongs_to :team, optional: true
  has_many :contracts, dependent: :destroy
  accepts_nested_attributes_for :contracts, allow_destroy: true
end
