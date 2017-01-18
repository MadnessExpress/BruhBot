module BruhBot
  module Plugins
    # Reaction face plugin
    module Reactions
      extend Discordrb::Commands::CommandContainer

      # Load config file
      reactions_conf = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'react')
        db.close if db
      end

      command(
        :react, min_args: 1, max_args: 1,
        permitted_roles: [],
        description: 'Shows a random smug reaction picture',
        parameters: reactions_conf['available_reactions']
      ) do |event, reaction|
        break if reactions_conf[reaction].nil?
        # Output a random image link from the config array
        event.respond reactions_conf[reaction].sample
      end
    end
  end
end
