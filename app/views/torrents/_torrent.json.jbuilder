json.extract! torrent, :id, :title, :release_year, :url, :main, :created_at, :updated_at
json.url torrent_url(torrent, format: :json)
