class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.references :publisher, index: true
      t.references :designer, index: true
      t.integer :price
      t.integer :msrp
      t.string :imageUrl
      t.date :releasedate
      t.integer :playerMin
      t.integer :playerMax
      t.integer :timeMin
      t.integer :timeMax

      t.timestamps null: false
    end
    add_foreign_key :items, :publishers
    add_foreign_key :items, :designers
  end
end
