class AddUsersToAddresses < ActiveRecord::Migration
  def change
    add_reference :addresses, :user, index: true
    add_foreign_key :addresses, :users
  end
end
