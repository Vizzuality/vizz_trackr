class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.string :code
      t.float :value

      t.timestamps
    end
  end
end
