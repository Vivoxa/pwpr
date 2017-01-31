class CreateLeavingBusinesses < ActiveRecord::Migration
  def change
    create_table :leaving_businesses do |t|
      t.string :scheme_ref
      t.string :npwd
      t.string :company_name
      t.string :company_number
      t.integer :subsidiaries_number

      t.timestamps null: false
    end
  end
end
