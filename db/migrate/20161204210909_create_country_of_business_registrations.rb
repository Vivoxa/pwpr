class CreateCountryOfBusinessRegistrations < ActiveRecord::Migration
  def change
    create_table :country_of_business_registrations do |t|
      t.string  :country, null: false
      t.timestamps null: false
    end
  end
end
