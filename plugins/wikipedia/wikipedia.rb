module BruhBot
  module Plugins
    # Wikipedia plugin
    module WikipediaPlugin
      require 'wikipedia'

      if File.exist?('plugins/update.txt')
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'wiki')
        db.close if db
      end

      extend Discordrb::Commands::CommandContainer
      command(
        :wiki, min_args: 1,
        permitted_roles: [],
        description: 'Look up a page on wikipedia',
        usage: 'wiki <topic>'
      ) do |event, *topic|
        page = Wikipedia.find(topic.join(' '))
        event.respond(page.fullurl)
      end
    end
  end
end
