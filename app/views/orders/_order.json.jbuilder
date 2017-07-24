json.extract! order, :id, :user_id, :billingaddress_id, :deliveryaddress_id, :created_at, :updated_at
json.url order_url(order, format: :json)
