json.array!(@characters) do |character|
  json.extract! character, :id, :name, :slug, :description, :age
  json.url character_url(character, format: :json)
end
