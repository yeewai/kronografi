json.array!(@concepts) do |concept|
  json.extract! concept, :id, :name, :slug, :description, :age
  json.url concept_url(concept, format: :json)
end
