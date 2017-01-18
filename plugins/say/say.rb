module BruhBot
  module Plugins
    # Plugin to make the bot say stuff
    module Say
      extend Discordrb::Commands::CommandContainer

      # Load config file
      say_conf = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) '\
                   'VALUES (?), (?)', 'say', 'say.channel')
      end

      command(
        :say, min_args: 1,
        permitted_roles: [],
        description: 'Make the bot say stuff.',
        usage: 'say <stuff>'
      ) do |event, *message|
        event.message.delete
        event.respond message.join(' ')
      end

      command(
        %s(say.channel), min_args: 2,
        permitted_roles: [],
        description: 'Send a message to another channel.',
        usage: 'say.channel <channel name> <message>'
      ) do |event, channel, *message|
        # Gets array of matching channels in the specified server.
        channelarray = event.bot.find_channel(channel, say_conf['servername'])
        # Sends message to the specified channel in the specified server.
        event.bot.send_message(channelarray[0], message.join(' '))
      end
    end
  end
end
