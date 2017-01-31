class CreateSicCodes < ActiveRecord::Migration
  def change
    create_table :sic_codes do |t|
      t.string :code, null: false
      t.string :year_introduced
      t.boolean :active, default: false, null: false

      t.timestamps null: false
    end
  end
end
