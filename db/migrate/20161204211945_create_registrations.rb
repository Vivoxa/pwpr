class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :agency_template_upload, null: false, foreign_key: { on_delete: :cascade }
      t.references :sic_code, foreign_key: true, null: false
      t.references :packaging_sector_main_activity, null: false, foreign_key: { on_delete: :cascade }
      t.references :submission_type, foreign_key: true
      t.references :resubmission_reason, foreign_key: true
      t.references :business, foreign_ley: true, null: false
      t.decimal :turnover, precision: 10, scale: 2, null: false
      t.boolean :licensor
      t.boolean :allocation_method_used

      t.timestamps null: false
    end
  end
end
