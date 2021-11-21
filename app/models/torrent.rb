class Torrent < ApplicationRecord
  validates :title, uniqueness: true
end
