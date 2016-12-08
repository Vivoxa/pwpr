class CreateLeavers < ActiveRecord::Migration
  def change
    create_table :leavers do |t|
      t.references :business, foreign_key: true, null: false
      t.references :leaving_code, foreign_key: true, null: false
      t.references :agency_template_upload, foreign_key: true, null: false
      t.date :date, null: false, null: false
      t.decimal :total_recovery_previous, null: false
      t.boolean :sub_leaver
      t.date :scheme_registration_date, null: false

      t.timestamps null: false
    end
  end
end
