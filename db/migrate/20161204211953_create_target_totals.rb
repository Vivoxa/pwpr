class CreateTargetTotals < ActiveRecord::Migration
  def change
    create_table :target_totals do |t|
      t.references :regular_producer_detail, foreign_key: true
      t.float :total_recycling_obligation
      t.float :total_recovery_obligation
      t.float :total_material_specific_recycling_obligation
      t.float :adjusted_total_recovery_obligation
      t.float :ninetytwo_percent_min_recycling_target

      t.timestamps null: false
    end
  end
end
