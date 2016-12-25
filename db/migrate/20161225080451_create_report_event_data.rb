class CreateReportEventData < ActiveRecord::Migration
  def change
    create_table :report_event_data do |t|
      t.string :report_type
      t.string :year
      t.integer :current_user_id
      t.string :current_user_type
      t.string :business_ids

      t.timestamps null: false
    end
  end
end
