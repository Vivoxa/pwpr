class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.references :target_field, foreign_key: true
      t.references :annual_target_set, foreign_key: true
      t.string :year
      t.float :value

      t.timestamps null: false
    end
  end
end
