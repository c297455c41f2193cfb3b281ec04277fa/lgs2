class CreateItemsOrdersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :items_orders, :id => false do |t|
      t.integer :item_id
      t.integer :order_id
    end

    add_index :items_orders, [:item_id, :order_id]
  end

  def self.down
    drop_table :items_orders
  end
end