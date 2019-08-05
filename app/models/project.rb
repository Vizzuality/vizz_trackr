class Project < ApplicationRecord
  has_many :report_parts
  has_many :reports, through: :report_parts
  has_many :users, through: :reports
end
