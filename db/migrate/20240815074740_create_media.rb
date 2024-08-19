class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.string :file
      t.string :media_type
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
