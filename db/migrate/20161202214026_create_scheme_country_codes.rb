class CreateSchemeCountryCodes < ActiveRecord::Migration
  def change
    create_table :scheme_country_codes do |t|
      t.string :country, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
