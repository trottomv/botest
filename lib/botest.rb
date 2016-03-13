require 'dotenv'
require 'telegram/bot'
require 'xkcd'
require 'rss'
require 'feed-normalizer'
require 'open-uri'
require 'simple-rss'
require 'open-uri'
require 'curb'

class Botest
Dotenv.load
token = ENV['TOKEN']
feed = FeedNormalizer::FeedNormalizer.parse open('http://xkcd.com/rss.xml')

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hi, #{message.from.first_name}")
    when /^\/(xkcd|comics)/
      bot.api.send_message(chat_id: message.chat.id, text: XKCD.img)
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye bye, #{message.from.first_name}")
    when '/feed'
      url = 'http://xkcd.com/rss.xml'
      open(url) do |rss|
        rss = RSS::Parser.parse(rss)
        bot.api.send_message(chat_id: message.chat.id, text: "Feed: #{rss.channel.title}")
        rss.items.each do |item|
          bot.api.send_message(chat_id: message.chat.id, text: "#{item.title} #{item.link}")
        end
      end
    when '/lastxkcd'
      bot.api.send_message(chat_id: message.chat.id, text: "#{feed.entries.first.url}")
    end
  end
end
end

def rssCal
Dotenv.load

rsscal = SimpleRSS.parse open('#{ENV[FEED_CAL]}')

timefeed=rsscal.items.first.pubDate.strftime ("%d-%m-%Y %H")
nowh=Time.now.strftime ("%d-%m-%Y %H")
case timefeed
 when nowh
  http = Curl.get("https://api.telegram.org/bot#{ENV['TOKEN']}/sendMessage?chat_id=#{ENV['CHAT_ID']}&text=#{rss.items.first.title}")
end
end

def rssXkcd
Dotenv.load

rss = SimpleRSS.parse open('http://xkcd.com/rss.xml')

timefeed=rss.items.first.pubDate.strftime ("%d-%m-%Y")
today=Time.now.strftime ("%d-%m-%Y")
case timefeed
 when today
  http = Curl.get("https://api.telegram.org/bot#{ENV['TOKEN']}/sendMessage?chat_id=#{ENV['CHAT_ID']}&text=#{rss.items.first.link}")
end
end

def rssturnoffus
Dotenv.load

rss = SimpleRSS.parse open('http://turnoff.us/feed.xml')

timefeed=rss.items.first.pubDate.strftime ("%d-%m-%Y %H")
nowh=Time.now.strftime ("%d-%m-%Y %H")
case timefeed
 when nowh
  http = Curl.get("https://api.telegram.org/bot#{ENV['TOKEN']}/sendMessage?chat_id=#{ENV['CHAT_ID']}&text=#{rss.items.first.link}")
end
end