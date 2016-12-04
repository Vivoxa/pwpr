class CreateSicCodes < ActiveRecord::Migration
  def change
    create_table :sic_codes do |t|
      t.string :code
      t.boolean :active
      t.string :year_introduced

      t.timestamps null: false
    end
  end
end
