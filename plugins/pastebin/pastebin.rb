module BruhBot
  module Plugins
    # Pastebin plugin
    module Paste
      require 'pastebin-api'
      extend Discordrb::Commands::CommandContainer

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'paste')
      end

      command(
        :paste, min_args: 1,
        permitted_roles: [],
        description: 'Creates a Pastebin paste with the specified text.',
        usage: 'paste <text>'
      ) do |event, *text|
        pastebin = Pastebin::Client.new(BruhBot.api['pastebin_api_key'])
        event.respond pastebin.newpaste(text.join(' '))
      end
    end
  end
end
