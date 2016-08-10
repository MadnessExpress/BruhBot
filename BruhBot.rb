#!/home/atlas/.rbenv/shims/ruby

require "discordrb"
require "googl"
require "yaml"
require "pastebin-api"
require "sqlite3"
require "ruby_cleverbot"

data = YAML::load_file(File.join(__dir__, 'config.yml'))
apidata = YAML::load_file(File.join(__dir__, 'apikeys.yml'))

commandprefix = data["prefix"]

discordtoken = apidata["discordtoken"]
discordappid = apidata["discordappid"]

bot = Discordrb::Commands::CommandBot.new token: discordtoken, application_id: discordappid, prefix: commandprefix

Dir["plugins/*/*.rb"].each do |file|
  load file
  if @export != nil
        @export.each { |m| bot.include!(self.class.const_get(m)) }
  end
end

# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
puts "This bot's invite URL is #{bot.invite_url}&permissions=261120"
puts 'Click on it to invite it to your server.'

bot.run
