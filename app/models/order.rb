class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :billingaddress, :class_name => 'Address'
  belongs_to :deliveryaddress, :class_name => 'Address'
  has_and_belongs_to_many :items
end
