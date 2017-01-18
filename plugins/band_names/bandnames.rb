module BruhBot
  module Plugins
    # Band names plugin
    module BandNames
      require('requiredmodules.rb')

      extend Discordrb::Commands::CommandContainer

      bandnames_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'

        db.execute <<-SQL
          create table if not exists bandnames (
            name text,
            UNIQUE(name)
          );
        SQL

        db.execute(
          'INSERT OR IGNORE INTO perms (command) '\
          'VALUES (?), (?), (?)', 'band', 'band.add', 'band.remove'
        )
        db.close if db
      end

      command(
        :band, min_args: 0,
        permitted_roles: [],
        description: 'Display a random band name.',
        usage: 'band'
      ) do |event|
        # Load database
        db = SQLite3::Database.new 'db/server.db'
        rows = db.execute('SELECT name FROM bandnames')
        db.close if db

        unless rows == []
          output = "#{rows.sample.sample} is #{event.user.display_name}'s "\
                   'new band name'
        end
        output = 'There are no bands.' unless rows != []

        event.channel.send_embed do |e|
          e.thumbnail = { url: bandnames_config['embed_image'] }
          e.add_field name: 'Band Name:', value: output, inline: true
          e.color = bandnames_config['embed_color']
        end
      end

      command(
        %s(band.add), min_args: 1,
        permitted_roles: [],
        description: 'Add a band name to the database.',
        usage: 'band add <text>'
      ) do |event, *text|
        event.message.delete

        # Load database
        db = SQLite3::Database.new 'db/server.db'

        begin
          db.execute(
            'INSERT OR IGNORE INTO bandnames (name) '\
            'VALUES (?)', [text.join(' ')]
          )
        rescue SQLite3::Exception
          event.respond 'That band name already exists.'
          break
        end

        db.close if db

        event.channel.send_embed do |e|
          e.thumbnail = { url: bandnames_config['embed_image'] }
          e.description = 'The following band was added to the database:'
          e.add_field name: 'Band:', value: text.join(' '), inline: false
          e.add_field name: 'Added By:', value: event.user.display_name,
                      inline: false
          e.color = bandnames_config['embed_color']
        end
      end

      command(
        %s(band.remove), min_args: 1,
        permitted_roles: [],
        description: 'Remove a band from your quote database.',
        usage: 'band.remove <text>'
      ) do |event, *text|
        event.message.delete

        db = SQLite3::Database.new 'db/server.db'
        check = db.execute('SELECT count(*) FROM bandnames '\
                           'WHERE name = ?', [text.join(' ')])[0][0]
        break event.respond 'That band doesn\'t exist.' unless check == 1

        db.execute('DELETE FROM bandnames WHERE name = ?', [text.join(' ')])
        db.close if db

        event.channel.send_embed do |e|
          e.thumbnail = { url: bandnames_config['embed_image'] }
          e.description = 'The following band name '\
                          'was removed from the database:'
          e.add_field name: 'Band Name:', value: text.join(' '), inline: false
          e.add_field name: 'Removed By:', value: event.user.display_name,
                      inline: false
          e.color = bandnames_config['embed_color']
        end
      end
    end
  end
end
