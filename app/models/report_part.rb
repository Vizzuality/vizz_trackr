class ReportPart < ApplicationRecord
  belongs_to :report
  belongs_to :project
end
