class CreateAgencyTemplateUploads < ActiveRecord::Migration
  def change
    create_table :agency_template_uploads do |t|
      t.timestamp :uploaded_at, null: false
      t.references :scheme, index: true, foreign_key: true, null: false
      t.integer :uploaded_by_id, null: false
      t.string :uploaded_by_type, null: false
      t.integer :year, null: false
      t.string :status
      t.string :filename, null: false

      t.timestamps null: false
    end
  end
end
