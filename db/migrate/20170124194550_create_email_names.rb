class CreateEmailNames < ActiveRecord::Migration
  def change
    create_table :email_names do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
