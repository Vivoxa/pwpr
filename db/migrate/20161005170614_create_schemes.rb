class CreateSchemes < ActiveRecord::Migration
  def change
    create_table :schemes do |t|
      t.string :name
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
