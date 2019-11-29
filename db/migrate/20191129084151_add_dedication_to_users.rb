class AddDedicationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dedication, :float, null: false, default: 0.74
  end
end
