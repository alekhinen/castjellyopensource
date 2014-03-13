json.array!(@podcasts) do |podcast|
  json.extract! podcast, :id, :title, :description, :link, :tags, :views, :created_at
  json.url podcast_url(podcast, format: :json)
end
