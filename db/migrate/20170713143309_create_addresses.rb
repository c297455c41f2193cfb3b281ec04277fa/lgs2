class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :line2
      t.string :postcode
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :addresses, :users
  end
end
