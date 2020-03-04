class CreateProjectLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :project_links do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
