class CreateTradeAssociationMethods < ActiveRecord::Migration
  def change
    create_table :trade_association_methods do |t|
      t.string :method, null: false
      t.string :description
      
      t.timestamps null: false
    end
  end
end
