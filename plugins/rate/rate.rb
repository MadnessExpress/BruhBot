module BruhBot
  module Plugins
    # Rate plugin
    module Rate
      extend Discordrb::Commands::CommandContainer

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'rate')
        db.close if db
      end

      command(
        :rate, min_args: 1,
        permitted_roles: [],
        description: 'Rate things!',
        usage: 'rate <stuff>'
      ) do |event, *text|
        event.respond "I give #{text.join(' ')} a "\
                      "#{rand(0.0..10.0).round(1)}/10.0!"
      end
    end
  end
end
