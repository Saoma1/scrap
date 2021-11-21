class WebScraper < ApplicationRecord
  def init_options
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    # options.binary = ENV['GOOGLE_CHROME_PATH']
    options.binary = ENV['FIREFOX_BIN']

    @driver = Selenium::WebDriver.for :firefox, options: options
    @wait = Selenium::WebDriver::Wait.new(timeout: 2) # seconds
    @base_url = 'https://1337x.to'
    @start_url = 'https://1337x.to/cat/Movies/'
  end

  def parse
    init_options
    start_page = 8
    today = DateTime.now
    yesterday = (today - 1)


    catch(:done) do
      loop do
        @driver.get "#{@start_url}#{start_page}/"
        response = Nokogiri::HTML(@driver.page_source)
        response.css('tbody tr').each do |app|
          alt_href = app.css('td.name a:nth-of-type(2)').attr('href') #on the main page
          date = app.css('td.coll-date').text.to_s
          date = DateTime.parse(date)

          throw(:done, true) if date < yesterday

          @driver.get (@base_url + alt_href)
          main_torrent_page = Nokogiri::HTML(@driver.page_source)
          puts "from model"
          save(main_torrent_page, alt_href)
          puts "sleep 2 seconds"
          puts "on page #{start_page}"
          puts `ps -o rss #{$$}`.strip.split.last.to_i
          sleep(1)
        end
        start_page += 1
      end
    end
    @driver.quit
  end

  private

  def save(main_torrent_page, alt_href)
    # item = {}
    if main_torrent_page.css('div#mCSB_1_container').any?
      a = main_torrent_page.css('div#mCSB_1_container h3 a')
      Torrent.create(
        title: a.text,
        url: @base_url + a.attr('href').to_s,
        main: true,
        release_year: a.attr('href').to_s[-5..-2],
      )
      # item[:main] = true
      # item[:url] = @base_url + a.attr('href').to_s
      # item[:title] = a.text
      # item[:release_year] = a.attr('href').to_s[-5..-2]
    else
      Torrent.create(
        title: main_torrent_page.css('div.box-info-heading h1').text,
        url: @base_url + alt_href.to_s,
        main: false,
        release_year: 'not yet',
      )
      # item[:main] = false
      # item[:url] = @base_url + alt_href.to_s
      # item[:release_year] = 'not yet'
      # item[:title] = main_torrent_page.css('div.box-info-heading h1').text
    end
    # puts `ps -o rss #{$$}`.strip.split.last.to_i
    # puts 'RAM USAGE: ' + `pmap #{Process.pid} | tail -1`[10,40].strip
    # Torrent.create(item)
  end
end
