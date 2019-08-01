class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.references :team, null: false, foreign_key: true
      t.references :roles, null: false, foreign_key: true

      t.timestamps
    end
  end
end
