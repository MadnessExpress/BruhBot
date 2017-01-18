module BruhBot
  module Plugins
    # Avatar plugin
    module Avatar
      extend Discordrb::Commands::CommandContainer

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'avatar')
      end

      command(
        :avatar, min_args: 1, max_args: 1,
        permitted_roles: [],
        description: 'Fetches a user\'s avatar.'
      ) do |event, arg|
        parse = event.bot.parse_mention(arg)
        break event.respond 'You must mention a user' if parse.nil?
        event.respond parse.avatar_url
      end

      command(
        %s(avatar.server), max_args: 0,
        permitted_roles: [],
        description: 'Fetches a server\'s avatar.'
      ) do |event|
        event.respond event.server.icon_url
      end
    end
  end
end
