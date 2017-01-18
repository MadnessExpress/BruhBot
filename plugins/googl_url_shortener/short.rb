module BruhBot
  module Plugins
    # URL shortener plugin
    module Short
      require 'googl'

      extend Discordrb::Commands::CommandContainer

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'short')
      end

      command(
        :short, min_args: 1, max_args: 1,
        permitted_roles: [],
        description: 'Shorten a URL with Googl.',
        usage: 'short <URL>'
      ) do |event, url|
        event.message.delete
        url = Googl.shorten(
          url, BruhBot.api['googl_ip'], BruhBot.api['googl_api_key']
        )
        event.respond url.short_url
      end
    end
  end
end
