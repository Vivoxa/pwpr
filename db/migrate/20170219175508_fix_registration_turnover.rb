class FixRegistrationTurnover < ActiveRecord::Migration
  def change
    change_column :registrations, :turnover, :decimal, precision: 15, scale: 3, null: false
  end
end
