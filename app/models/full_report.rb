# == Schema Information
#
# Table name: full_reports
#
#  project_id            :bigint
#  project_name          :string
#  project_is_billable   :boolean
#  contract_id           :bigint
#  contract_name         :string
#  reporting_period_id   :bigint
#  reporting_period_name :text
#  reporting_period_date :date
#  user_id               :bigint
#  user_name             :string
#  role_id               :bigint
#  role_name             :string
#  team_id               :bigint
#  team_name             :string
#  report_id             :bigint
#  report_estimated      :boolean
#  percentage            :float
#  cost                  :float
#  days                  :float
#

class FullReport < ApplicationRecord
  belongs_to :reporting_period
  belongs_to :contract
  belongs_to :project
  belongs_to :report
  belongs_to :team
  belongs_to :user

  scope :for_team, ->(team_id) { where(team_id: team_id) }
  scope :for_role, ->(role_id) { where(role_id: role_id) }
  scope :for_contract, ->(contract_id) { where(contract_id: contract_id) }
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :bigger_than, ->(threshold) { where('percentage > ?', threshold.to_f) }

  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end

  def contract_full_name
    "#{contract_name} [#{project_name}]"
  end

  def self.contracts_distribution filters
    inner_query = filtered(filters)
    select_query = <<-SQL
      reporting_period_id,
      team_name,
      user_id,
      COUNT(DISTINCT(contract_id)) AS total_contracts
    SQL
    inner_query = inner_query.select(select_query)
    inner_query = inner_query.group(:reporting_period_id,
                                    :team_name,
                                    :user_id)
    results = unscoped
      .select('reporting_period_id, team_name, array_agg(total_contracts) AS contracts')
      .from(inner_query, :inner_query)
      .group(:reporting_period_id, :team_name)
    results
  end

  def self.filtered filters
    results = all

    results = results.for_team(filters[:team_id]) if filters[:team_id].present?
    results = results.for_role(filters[:role_id]) if filters[:role_id].present?
    results = results.for_user(filters[:user_id]) if filters[:user_id].present?
    results = results.for_contract(filters[:contract_id]) if filters[:contract_id].present?
    results = results.bigger_than(filters[:threshold]) if filters[:threshold].present?

    results
  end
end
