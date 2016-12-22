class CreateLicensors < ActiveRecord::Migration
  def change
    create_table :licensors do |t|
      t.references :business, foreign_key: true, null: false
      t.references :agency_template_upload, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
