class CreateLeavers < ActiveRecord::Migration
  def change
    create_table :leavers do |t|
      t.references :business, foreign_key: true
      t.references :leaving_code, foreign_key: true
      t.references :agency_template_upload, foreign_key: true
      t.date :date, null: false
      t.decimal :total_recovery_previous, precision: 5, scale: 2
      t.boolean :sub_leaver
      t.date :scheme_registration_date

      t.timestamps null: false
    end
  end
end
