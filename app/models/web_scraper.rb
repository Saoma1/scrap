class WebScraper < ApplicationRecord
  def selenium_options
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument("--enable-javascript")
    options.add_argument("window-size=1400,900")
    options.binary = ENV['FIREFOX_BIN']
    options
  end

  def selenium_profile
    profile = Selenium::WebDriver::Firefox::Profile.new
  end

  def init_options
    Selenium::WebDriver::Firefox::Service.driver_path=ENV['GECKODRIVER_PATH']
    caps = [
      selenium_options,
    ]

    @driver = Selenium::WebDriver.for(:firefox, capabilities: caps)

    @base_url = 'https://1337x.to'
    @start_url = 'https://1337x.to/cat/Movies/'
  end

  def parse
    init_options
    start_page = 7
    today = DateTime.now
    yesterday = (today - 1)
    nr = 1


    catch(:done) do
      loop do
        @driver.navigate.to "#{@start_url}#{start_page}/"
        # wait.until { @driver.find_element(id: "foo") }
        puts
        puts "right after site change, page: #{start_page}"
        response = Nokogiri::HTML(@driver.page_source)
        # puts response
        @driver.save_screenshot("./screen.png")
        response.css('tbody tr').each do |app|
          alt_href = app.css('td.name a:nth-of-type(2)').attr('href') #on the main page
          date_before = app.css('td.coll-date').text.to_s
          puts
          puts "date before conversion: #{date_before}"
          date = DateTime.parse(date_before)

          throw(:done, true) if date < yesterday

          @driver.navigate.to (@base_url + alt_href)
          main_torrent_page = Nokogiri::HTML(@driver.page_source)
          puts "redirect url: #{(@base_url + alt_href).to_s.colorize(:yellow)}"
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
    item = {}
    if main_torrent_page.css('div#mCSB_1_container').any?
      a = main_torrent_page.css('div#mCSB_1_container h3 a')
      item[:title] = a.text
      item[:release_year] = a.attr('href').to_s[-5..-2]
      item[:url] = @base_url + a.attr('href').to_s
      item[:main] = true
      # Torrent.create(
      #   title: a.text,
      #   url: @base_url + a.attr('href').to_s,
      #   main: true,
      #   release_year: a.attr('href').to_s[-5..-2],
      # )
    else
      item[:title] = main_torrent_page.css('div.box-info-heading h1').text
      item[:release_year] = 'not yet'
      item[:url] = @base_url + alt_href.to_s
      item[:main] = false
      # Torrent.create(
        #   title: main_torrent_page.css('div.box-info-heading h1').text,
        #   url: @base_url + alt_href.to_s,
        #   main: false,
        #   release_year: 'not yet',
        # )
    end
    begin
      Torrent.create!(item)
      puts "Torrent saved #{item}".colorize(:green)
    rescue
      puts "Torrent Exists!".colorize(:red)
    end
  end
end
