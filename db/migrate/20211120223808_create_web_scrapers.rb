class CreateWebScrapers < ActiveRecord::Migration[6.1]
  def change
    create_table :web_scrapers do |t|

      t.timestamps
    end
  end
end
