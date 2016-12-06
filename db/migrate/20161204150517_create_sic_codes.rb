class CreateSicCodes < ActiveRecord::Migration
  def change
    create_table :sic_codes do |t|
      t.string :code, null: false
      t.boolean :active
      t.string :year_introduced, null: false

      t.timestamps null: false
    end
  end
end
