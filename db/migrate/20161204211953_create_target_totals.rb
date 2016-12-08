class CreateTargetTotals < ActiveRecord::Migration
  def change
    create_table :target_totals do |t|
      t.references :regular_producer_detail, foreign_key: true, null: false
      t.decimal :total_recycling_obligation, null: false
      t.decimal :total_recovery_obligation, null: false
      t.decimal :total_material_specific_recycling_obligation, null: false
      t.decimal :adjusted_total_recovery_obligation, null: false
      t.decimal :ninetytwo_percent_min_recycling_target, null: false

      t.timestamps null: false
    end
  end
end
