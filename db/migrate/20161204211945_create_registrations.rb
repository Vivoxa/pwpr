class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :agency_template_upload, foreign_key: true, null: false
      t.references :sic_code, foreign_key: true, null: false
      t.references :packaging_sector_main_activity, foreign_key: true, null: false
      t.references :submission_type, foreign_key: true, null: false
      t.references :resubmission_reason, foreign_key: true
      t.references :business, foreign_ley: true, null: false
      t.references :change_detail, foreign_ley: true
      t.decimal :turnover, precision: 10, scale: 2, null: false
      t.boolean :licensor
      t.boolean :allocation_method_used

      t.timestamps null: false
    end
  end
end
