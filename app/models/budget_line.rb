class BudgetLine < ApplicationRecord
  belongs_to :contract
  belongs_to :role, optional: true
end
