class CreateEmailContents < ActiveRecord::Migration
  def change
    create_table :email_contents do |t|
      t.integer :scheme_id
      t.references :email_content_type, index: true, foreign_key: true
      t.references :email_name, index: true, foreign_key: true
      t.string :intro, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.text :address, null: false
      t.string :footer, null: false

      t.timestamps null: false
    end
  end
end
