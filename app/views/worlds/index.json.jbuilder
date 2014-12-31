json.array!(@worlds) do |world|
  json.extract! world, :id, :name, :description
  json.url world_url(world, format: :json)
end
