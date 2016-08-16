#!/home/atlas/.rbenv/shims/ruby

require "discordrb"
require "googl"
require "yaml"
require "pastebin-api"
require "sqlite3"
require "ruby_cleverbot"
require "wikipedia"
require "youtube_it"

$LOAD_PATH << File.join(File.dirname(__FILE__))

data = YAML::load_file("config.yml")
apidata = YAML::load_file("apikeys.yml")

commandprefix = data["prefix"]

discordtoken = apidata["discordtoken"]
discordappid = apidata["discordappid"]

bot = Discordrb::Commands::CommandBot.new token: discordtoken, application_id: discordappid, prefix: commandprefix

Dir["plugins/*/*/*.rb"].each do |file|
  load file
  if @export != nil
        @export.each { |m| bot.include!(self.class.const_get(m)) }
  end
end

  bot.command(:update, min_args: 0, max_args: 0, description: "Update the bot.", usage: "update") do |event|
    data = YAML::load_file("owneroptions.yml")
    break unless data["ownerid"].include? event.user.id
    event.respond "Updating and restarting!"
    event.bot.stop && exec("update.sh")
  end

  bot.command(:shutdown, help_available: false) do |event|
    data = YAML::load_file("owneroptions.yml")
    break unless data["ownerid"].include? event.user.id
    data = YAML::load_file("owneroptions.yml")
    event.respond "#{data["shutdownmessage"].sample}"
    event.bot.stop
  end

  bot.command(:game,  min_args: 1, description: "sets bot game") do |event, *game|  
    data = YAML::load_file("owneroptions.yml")
    break unless data["ownerid"].include? event.user.id
    event.bot.game = game.join(" ")
    nil
  end

  bot.command(:db, min_args: 0, max_args: 0, description: "Manage database.") do |event|
    data = YAML::load_file("owneroptions.yml")
    break unless (event.user.id == event.server.owner.id) || (data["ownerid"].include? event.user.id)
    Dir.mkdir("db") unless File.exists?("db")
    Dir.mkdir("logs") unless File.exists?("logs")
    Dir.mkdir("logs/commandlogs") unless File.exists?("logs/commandlogs")
    Dir.mkdir("logs/messagelogs") unless File.exists?("logs/messagelogs")
    db = SQLite3::Database.new "db/#{event.server.id}.db"

    db.execute <<-SQL
      create table if not exists quotes (
        quote text,
        UNIQUE(quote)
      );          
    SQL

    event.respond "Database has been set up."
  end
  
# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
# done once, afterwards, you can remove this part if you want
puts "This bot's invite URL is #{bot.invite_url}&permissions=261120"
puts 'Click on it to invite it to your server.'

bot.run
