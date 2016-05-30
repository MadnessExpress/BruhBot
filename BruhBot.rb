#!/home/atlas/.rbenv/shims/ruby

require 'discordrb'
require 'cleverbot'

require_relative 'config.rb'

Dir['plugins/events/*.rb'].each { |r| require_relative r }
Dir['plugins/commands/*.rb'].each { |r| require_relative r }

bot = Discordrb::Commands::CommandBot.new token: discordtoken, application_id: discordappid, prefix: commandprefix

plugins.each { |m| bot.include! m }


# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.command(:shutdown, help_available: false) do |event|
  break unless event.user.id == 70979549097103360 # Replace number with your ID

  bot.send_message(event.channel.id, shutdownmessage)
  exit
end

bot.command(:game,  min_args: 1, description: "sets bot game") do |event, *game|
    event.bot.game = game.join(' ')
    nil

end

bot.run
