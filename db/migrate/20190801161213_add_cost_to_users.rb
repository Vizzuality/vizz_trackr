class AddCostToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :cost, :float
  end
end
