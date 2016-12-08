class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :membership_id
      t.string :company_no
      t.string :NPWD
      t.string :SIC
      t.references :scheme, index: true, foreign_key: true
      t.references :submission_type
      t.references :country_of_business_registration
      t.timestamps null: false
    end
  end
end
