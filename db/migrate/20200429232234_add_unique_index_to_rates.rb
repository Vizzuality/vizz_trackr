class AddUniqueIndexToRates < ActiveRecord::Migration[6.0]
  def change
    add_index :rates, :code, unique: true
  end
end
