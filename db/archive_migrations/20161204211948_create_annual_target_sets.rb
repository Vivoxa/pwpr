class CreateAnnualTargetSets < ActiveRecord::Migration
  def change
    create_table :annual_target_sets do |t|
      t.references :scheme_country_code, foreign_key: true, null: false
      t.decimal :value, precision: 5, scale: 2, null: false
      t.string :year, null: false

      t.timestamps null: false
    end
  end
end
