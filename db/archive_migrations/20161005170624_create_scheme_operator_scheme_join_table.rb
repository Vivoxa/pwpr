class CreateSchemeOperatorSchemeJoinTable < ActiveRecord::Migration
  def change
    create_join_table :scheme_operators, :schemes do |t|
      t.index :scheme_operator_id
      t.index :scheme_id
    end
  end
end
