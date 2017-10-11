class CreateEmailContentTypes < ActiveRecord::Migration
  def change
    create_table :email_content_types do |t|
      t.string :name,  null: false

      t.timestamps null: false
    end
  end
end
