class CreateAgencyTemplateUploads < ActiveRecord::Migration
  def change
    create_table :agency_template_uploads do |t|
      t.timestamp :uploaded_at
      t.references :scheme, index: true, foreign_key: true
      t.float :uploaded_by_id
      t.string :uploaded_by_type
      t.float :year
      t.string :status
      t.string :filename

      t.timestamps null: false
    end
  end
end
