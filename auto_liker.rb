require 'watir' # Crawler
require 'pry' # Ruby REPL
require 'rb-readline' # Ruby IRB
require_relative 'credentials' # Pulls in login credentials from credentials.rb

username = $username
password = $password
like_counter = 20
num_of_rounds = 1
MAX_LIKES = 1500

# Open Browser, Navigate to Login page
browser = Watir::Browser.new :chrome, switches: ['--incognito']
browser.goto "instagram.com/accounts/login/"

# Navigate to Username and Password fields, inject info
puts "Logging in..."
browser.text_field(:name => "username").set "#{username}"
browser.text_field(:name => "password").set "#{password}"

# Click Login Button
browser.button(:class => '_ah57t _84y62 _i46jh _rmr7s').click
sleep(2)
puts "We're in #DatCrawlLifeDoe"

# Continuous loop to break upon reaching the max likes
loop do
  # Scroll to bottom of window 3 times to load more results (20 per page)
  3.times do |i|
    browser.driver.execute_script("window.scrollBy(0,document.body.scrollHeight)")
    sleep(1)
  end

  # Call all unliked like buttons on page and click each one.
  if browser.span(:class => "coreSpriteHeartOpen").exists?
    browser.spans(:class => "coreSpriteHeartOpen").each { |val|
      val.click
      like_counter += 1
    }
    ap "Photos liked: #{like_counter}"
  else
    ap "No media to like rn, yo. Sorry homie, we tried."
  end
  num_of_rounds += 1
  puts "--------- #{like_counter / num_of_rounds} likes per round (on average) ----------"
  break if like_counter >= MAX_LIKES
  sleep(30) # Return to top of loop after this many seconds to check for new photos
end

# Leave this in to use the REPL at end of program
# Otherwise, take it out and program will just end
Pry.start(binding)