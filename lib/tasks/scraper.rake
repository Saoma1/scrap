require 'rake'

namespace :scraper do
  desc 'task description'
  task :execute => :environment do
    puts 'Soto, you are doing great'
    WebScraper.new.parse
  end
end

#  run with:
# bundle exec rake scraping:current_environment
# rake scraping:current_environment
