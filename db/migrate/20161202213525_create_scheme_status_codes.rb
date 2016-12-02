class CreateSchemeStatusCodes < ActiveRecord::Migration
  def change
    create_table :scheme_status_codes do |t|
      t.string :status, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
