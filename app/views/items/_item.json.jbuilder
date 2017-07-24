json.extract! item, :id, :name, :description, :publisher_id, :designer_id, :price, :msrp, :imageUrl, :releasedate, :playerMin, :playerMax, :timeMin, :timeMax, :created_at, :updated_at
json.url item_url(item, format: :json)
