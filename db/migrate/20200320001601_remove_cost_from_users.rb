class RemoveCostFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :cost, :float
  end
end
