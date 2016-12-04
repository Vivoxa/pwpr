class CreateLicensors < ActiveRecord::Migration
  def change
    create_table :licensors do |t|
      t.references :business, foreign_key: true
      t.references :agency_template_upload, foreign_key: true
      t.string :year
      t.string :licensee_scheme_ref_no

      t.timestamps null: false
    end
  end
end
