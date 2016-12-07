class CreateSicCodes < ActiveRecord::Migration
  def change
    create_table :sic_codes do |t|
      t.string :code
      t.string :year_introduced
      t.boolean :active

      t.timestamps null: false
    end
  end
end
