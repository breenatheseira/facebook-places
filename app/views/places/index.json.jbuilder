json.array!(@places) do |place|
  json.extract! place, :id, :business, :area
  json.url place_url(place, format: :json)
end
