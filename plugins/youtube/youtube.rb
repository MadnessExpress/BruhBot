module BruhBot
  module Plugins
    # Youtube plugin
    module Youtube
      require 'yourub'
      extend Discordrb::Commands::CommandContainer

      if File.exist?('plugins/update.txt')
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) '\
                   'VALUES (?)', 'youtube')
        db.close if db
      end

      command(
        :youtube, min_args: 1,
        permitted_roles: [],
        desc: 'Search for a Youtube video.',
        usage: 'youtube <search terms>'
      ) do |event, *query|
        options = { developer_key: BruhBot.api['youtube_api_key'] }
        client = Yourub::Client.new(options)

        client.search(query: query.join(' '), max_results: 1) do |v|
          event.respond "https://www.youtube.com/watch?v=#{v['id']}"
        end
        nil
      end
    end
  end
end
