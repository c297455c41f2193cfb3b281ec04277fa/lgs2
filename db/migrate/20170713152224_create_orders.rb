class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :billingaddress, index: true
      t.references :deliveryaddress, index: true

      t.timestamps null: false
    end
    add_foreign_key :orders, :users
    add_foreign_key :orders, :billingaddresses
    add_foreign_key :orders, :deliveryaddresses
  end
end
