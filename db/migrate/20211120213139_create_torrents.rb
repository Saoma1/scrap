class CreateTorrents < ActiveRecord::Migration[6.1]
  def change
    create_table :torrents do |t|
      t.string :title
      t.string :release_year
      t.string :url
      t.string :main

      t.timestamps
    end
  end
end
