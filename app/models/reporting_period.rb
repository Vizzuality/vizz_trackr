class ReportingPeriod < ApplicationRecord
  has_many :reports

  def display_name
    date.strftime("%B %Y")
  end
end
