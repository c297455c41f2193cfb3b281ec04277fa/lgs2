class RemoveUsersFromAddresses < ActiveRecord::Migration
  def change
    remove_reference :addresses, :user, index: true
    remove_foreign_key :addresses, :users
  end
end
