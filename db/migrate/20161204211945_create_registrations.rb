class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :agency_template_upload, foreign_key: true
      t.references :sic_code, foreign_key: true
      t.references :packaging_sector_main_activity, foreign_key: true
      t.references :country_of_business_registration, foreign_key: true
      t.references :change_to_application_or_obligation, references: :submission_types
      t.string :resubmission
      t.decimal :turnover
      t.boolean :licensor
      t.boolean :allocation_method_used

      t.timestamps null: false
    end
  end
end
