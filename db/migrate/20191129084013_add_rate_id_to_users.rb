class AddRateIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :rate, foreign_key: true
  end
end
