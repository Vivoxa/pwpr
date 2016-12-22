class CreateLeavers < ActiveRecord::Migration
  def change
    create_table :leavers do |t|
      t.references :business, foreign_key: true
      t.references :leaving_code, foreign_key: true, null: false
      t.references :agency_template_upload, foreign_key: true, null: false
      t.references :leaving_business, foreign_key: true
      t.date :leaving_date, null: false
      t.decimal :total_recovery_previous, precision: 6, scale: 2
      t.boolean :sub_leaver, default: false
      t.string :scheme_comments

      t.timestamps null: false
    end
  end
end
