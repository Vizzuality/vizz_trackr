# == Schema Information
#
# Table name: full_reports
#
#  project_id            :bigint
#  project_name          :string
#  contract_id           :bigint
#  contract_name         :string
#  reporting_period_id   :bigint
#  reporting_period_name :text
#  user_id               :bigint
#  user_name             :string
#  role_id               :bigint
#  role_name             :string
#  team_id               :bigint
#  team_name             :string
#  percentage            :float
#  cost                  :float
#  days                  :float
#

class FullReport < ActiveRecord::Base

  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end
end
