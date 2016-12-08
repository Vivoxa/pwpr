class CreateJoiners < ActiveRecord::Migration
  def change
    create_table :joiners do |t|
      t.references :agency_template_upload, foreign_key: true, null: false
      t.references :business, foreign_key: true, null: false
      t.date :joining_date, null: false
      t.string :previously_registered_at
      t.decimal :total_recovery, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
