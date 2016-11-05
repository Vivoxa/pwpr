class CreateAgencyTemplateUploads < ActiveRecord::Migration
  def change
    create_table :agency_template_uploads do |t|
      t.timestamp :uploaded_at
      t.references :scheme, index: true, foreign_key: true
      t.integer :uploaded_by_id
      t.string :uploaded_by_type
      t.integer :year
      t.string :status

      t.timestamps null: false
    end
  end
end
