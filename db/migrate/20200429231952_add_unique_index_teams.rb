class AddUniqueIndexTeams < ActiveRecord::Migration[6.0]
  def change
    add_index :teams, :name, unique: true
  end
end
