class Report < ApplicationRecord
  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :role, optional: true
  belongs_to :reporting_period
  has_many :report_parts, dependent: :destroy
  accepts_nested_attributes_for :report_parts, allow_destroy: true
end
