class CreateSubsidiaries < ActiveRecord::Migration
  def change
    create_table :subsidiaries do |t|
      t.references :business, foreign_key: true, null: false
      t.references :agency_template_upload, foreign_key: true, null: false
      t.string :change_details

      t.timestamps null: false
    end
  end
end
