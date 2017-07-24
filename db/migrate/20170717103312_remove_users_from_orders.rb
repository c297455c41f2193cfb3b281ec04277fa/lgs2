class RemoveUsersFromOrders < ActiveRecord::Migration
  def change
    remove_reference :orders, :user, index: true
    remove_foreign_key :orders, :users
  end
end
