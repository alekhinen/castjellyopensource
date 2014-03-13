json.array!(@shows) do |show|
  json.extract! show, :id, :title, :description, :link, :tags, :views, :podcast_id
  json.url show_url(show, format: :json)
end
