class CreateEmailContents < ActiveRecord::Migration
  def change
    create_table :email_contents do |t|
      t.integer :scheme_id
      t.references :email_content_type, index: true, foreign_key: true
      t.references :email_name, index: true, foreign_key: true
      t.string :intro
      t.string :title
      t.text :body
      t.string :footer

      t.timestamps null: false
    end
  end
end
