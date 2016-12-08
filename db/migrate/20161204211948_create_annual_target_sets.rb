class CreateAnnualTargetSets < ActiveRecord::Migration
  def change
    create_table :annual_target_sets do |t|
      t.references :scheme_country_code, foreign_key: true
      t.decimal :value, precision: 5, scale: 2
      t.string :year

      t.timestamps null: false
    end
  end
end
