class WebScraper < ApplicationRecord
  def init_options

    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    # options.binary = ENV['GOOGLE_CHROME_PATH']
    options.binary = ENV['FIREFOX_BIN']

    # Selenium::WebDriver::Firefox::Binary.path=ENV['FIREFOX_BIN']
    Selenium::WebDriver::Firefox::Service.driver_path=ENV['GECKODRIVER_PATH']
    @driver = Selenium::WebDriver.for :firefox, options: options

    @base_url = 'https://1337x.to'
    @start_url = 'https://1337x.to/cat/Movies/'
  end

  def parse
    init_options
    start_page = 8
    today = DateTime.now
    yesterday = (today - 1)
    nr = 1


    catch(:done) do
      loop do
        @driver.get "#{@start_url}#{start_page}/"
        puts
        puts "right after site change, page: #{start_page}"
        response = Nokogiri::HTML(@driver.page_source)
        response.css('tbody tr').each do |app|
          alt_href = app.css('td.name a:nth-of-type(2)').attr('href') #on the main page
          date_before = app.css('td.coll-date').text.to_s
          puts
          puts "date before conversion: #{date_before}"
          date = DateTime.parse(date_before)

          throw(:done, true) if date < yesterday

          @driver.get (@base_url + alt_href)
          main_torrent_page = Nokogiri::HTML(@driver.page_source)
          save(main_torrent_page, alt_href)
          puts "date: #{date}"
          puts "item: number #{nr}, on page #{start_page}"
          puts "system mem: #{`ps -o rss #{$$}`.strip.split.last.to_i/1024}MB"
          sleep(1)
          nr += 1
        end
        nr = 1
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
    puts "saved #{alt_href}"
  end
end
