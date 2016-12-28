class CreateSubsidiaries < ActiveRecord::Migration
  def change
    create_table :subsidiaries do |t|
      t.references :business, foreign_key: true, null: false
      t.references :agency_template_upload, null: false, foreign_key: { on_delete: :cascade }
      t.references :change_detail, foreign_key: { on_delete: :cascade }
      t.references :packaging_sector_main_activity, null: false, foreign_key: { on_delete: :cascade }
      t.boolean :allocation_method_used, default: false

      t.timestamps null: false
    end
  end
end
