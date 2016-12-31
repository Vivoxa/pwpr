class CreateJoiners < ActiveRecord::Migration
  def change
    create_table :joiners do |t|
      t.references :agency_template_upload, null: false, foreign_key: { on_delete: :cascade }
      t.references :business, null: false, foreign_key: true
      t.date :joining_date, null: false
      t.date :date_scheme_registered, null: false
      t.string :previously_registered_at
      t.decimal :total_recovery, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
