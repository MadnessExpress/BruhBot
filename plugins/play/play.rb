module BruhBot
  module Plugins
    # Play plugin
    module Play
      extend Discordrb::Commands::CommandContainer

      # Load config file
      play_conf = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'play')
      end

      command(
        :play, min_args: 2,
        permitted_roles: [],
        description: 'Invite groups to play a game.',
        usage: 'play <gamename>, <groupname>'
      ) do |event, *text|
        event.message.delete

        # Convert array into string and back into an array separating game name 
        # and groups/people with a comma.
        infoarray = text.join(' ').split(', ')

        # Assign variables to insert into message
        gamename = infoarray[0]
        groupname = infoarray[1]
        usermentions = event.message.mentions
        rolementions = event.message.role_mentions

        usermentions.map! do |g|
          g = event.bot.member(event.server.id, g.id).display_name
        end

        rolementions.map! do |g|
          g = "#{g.name} Role"
        end

        (usermentions << rolementions).flatten!
        recipients = usermentions.join(', ')

        event.respond groupname
        event.channel.send_embed do |e|
          e.thumbnail = { url: play_conf['embed_image'] }
          e.description = play_conf['play_message'].sample
          e.add_field name: 'Game:',\
                      value: play_conf['game_name'] % { gamename: gamename },\
                      inline: false
          e.add_field name: 'Sender:', value: event.user.mention, inline: true
          e.add_field name: 'Recipients:', value: recipients, inline: true
          e.color = play_conf['embed_color']
        end
      end
    end
  end
end
