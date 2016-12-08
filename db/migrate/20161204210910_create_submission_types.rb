class CreateSubmissionTypes < ActiveRecord::Migration
  def change
    create_table :submission_types do |t|
      t.string :code, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
