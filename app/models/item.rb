class Item < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :designer
  has_and_belongs_to_many :orders
end
