class CreateLeavingCodes < ActiveRecord::Migration
  def change
    create_table :leaving_codes do |t|
      t.string :code, null: false
      t.string :reason

      t.timestamps null: false
    end
  end
end
