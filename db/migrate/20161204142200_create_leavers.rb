class CreateLeavers < ActiveRecord::Migration
  def change
    create_table :leavers do |t|
      t.references :business, foreign_key: true
      t.references :leaving_code, null: false, foreign_key: { on_delete: :cascade }
      t.references :agency_template_upload, null: false, foreign_key: { on_delete: :cascade }
      t.references :leaving_business, foreign_key: { on_delete: :cascade }
      t.date :leaving_date, null: false
      t.decimal :total_recovery_previous, precision: 6, scale: 2
      t.boolean :sub_leaver, default: false
      t.string :scheme_comments

      t.timestamps null: false
    end
  end
end
