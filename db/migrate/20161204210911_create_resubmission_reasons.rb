class CreateResubmissionReasons < ActiveRecord::Migration
  def change
    create_table :resubmission_reasons do |t|
      t.string :reason, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
