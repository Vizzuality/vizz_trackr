class ProgressReport < ApplicationRecord
  belongs_to :reporting_period
  belongs_to :contract
end
