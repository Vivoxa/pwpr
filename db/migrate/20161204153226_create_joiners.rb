class CreateJoiners < ActiveRecord::Migration
  def change
    create_table :joiners do |t|
      t.references :agency_template_upload, foreign_key: true
      t.references :business, foreign_key: true
      t.date :joining_date
      t.string :previously_registered_at
      t.float :total_recovery

      t.timestamps null: false
    end
  end
end
