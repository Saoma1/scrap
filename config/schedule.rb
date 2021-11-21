# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
# require 'tzinfo'

# Export current PATH to the cron
# env :PATH, ENV["PATH"]

# Use 24 hour format when using `at:` option
# set :chronic_options, hours24: true

# Use local_to_utc helper to setup execution time using your local timezone instead
# of server's timezone (which is probably and should be UTC, to check run `$ timedatectl`).
# Also maybe you'll want to set same timezone in kimurai as well (use `Kimurai.configuration.time_zone =` for that),
# to have spiders logs in a specific time zone format.
# Example usage of helper:
# every 1.day, at: local_to_utc("7:00", zone: "Europe/Moscow") do
#   crawl "google_spider.com", output: "log/google_spider.com.log"
# end
# def local_to_utc(time_string, zone:)
#   TZInfo::Timezone.get(zone).local_to_utc(Time.parse(time_string))
# end

# env :PATH, ENV["PATH"]

### How to set a cron schedule ###
# Run: `$ whenever --update-crontab --load-file config/schedule.rb`.
# If you don't have whenever command, install the gem: `$ gem install whenever`.

### How to cancel a schedule ###
# Run: `$ whenever --clear-crontab --load-file config/schedule.rb`.

# Use 24 hour format when using `at:` option
# set :chronic_options, hours24: true
# job_type :single, "cd :path && :environment_variable=:environment ruby :task :output"

# job_type :script,  "cd :path && :environment_variable=:environment bundle exec script/:task :output"

# job_type :single, "cd :path ruby :task :output"

# Learn more: http://github.com/javan/whenever
# every 1.minute do
#   # command "echo 'you can use raw cron syntax too'"
#   # single "web_scraper.rb", output: "web_scraper.log"
#   # rake "scraper:execute", output: "rake.log"
#   # runner "WebScraper.new.parse", output: "rake.log"
#   # runner "WebScrapper.some_process"
#   # single "web_scrapper.rb", output: "scrapper.log"
# end
