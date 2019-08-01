class Report < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :role
  belongs_to :reporting_period
  has_many :report_parts
  accepts_nested_attributes_for :report_parts, allow_destroy: true
end
