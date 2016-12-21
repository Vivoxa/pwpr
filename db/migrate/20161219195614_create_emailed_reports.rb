class CreateEmailedReports < ActiveRecord::Migration
  def change
    create_table :emailed_reports do |t|
      t.string :report_name
      t.string :year
      t.datetime :date_last_sent
      t.references :business, index: true, foreign_key: true
      t.integer :sent_by_id
      t.string :sent_by_type

      t.timestamps null: false
    end
  end
end
