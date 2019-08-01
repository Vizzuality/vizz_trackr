class Report < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :role
  belongs_to :reporting_period
end
