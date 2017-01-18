module BruhBot
  module Plugins
    # Permissions plugin
    module Permissions
      extend Discordrb::Commands::CommandContainer

      permissions_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      if File.exist?('plugins/update.txt')
        db = SQLite3::Database.new 'db/server.db'

        db.execute <<-SQL
          create table if not exists perms (
            command text,
            roles text,
            UNIQUE(command)
          );
        SQL

        db.execute('INSERT OR IGNORE INTO perms (command) '\
                   'VALUES (?), (?), (?), (?)', 'perm',\
                   'perm.list', 'perm.add', 'perm.remove')
      end

      command(
        :perm, min_args: 1,
        permitted_roles: [],
        description: 'View role/roles permission for a command',
        usage: 'perm <command>'
      ) do |event, command|
        db = SQLite3::Database.new 'db/server.db'
        role_array = db.execute('SELECT roles FROM perms '\
                                'WHERE command = ?', command)[0][0]
        role_array = role_array.split(',').map(&:to_i) unless role_array.nil?
        role_array = [] if role_array.nil?
        output = ''

        role_array.each do |r|
          role_id = event.server.role(r.to_i)
          output += "#{role_id.name} - #{r}\n"
        end

        output = 'N/A' unless output != ''

        event.channel.send_embed do |e|
          e.thumbnail = { url: permissions_config['embed_image'] }
          e.description = "The following roles have access:\n\n#{output}"
          e.color = permissions_config['embed_color']
        end
        nil
      end

      command(
        %s(perm.list), max_args: 0,
        permitted_roles: [],
        description: 'View role/roles permission for a command',
        usage: 'perm <command>'
      ) do |event|
        db = SQLite3::Database.new 'db/server.db'
        perm_array = db.execute('SELECT command FROM perms')
        output = ''

        perm_array.each do |perm|
          output += "-#{perm.join('')}\n"
        end

        output = 'N/A' unless output != ''

        event.channel.send_embed do |e|
          e.thumbnail = { url: permissions_config['embed_image'] }
          e.description = "The following permissions are configurable:\n\n#{output}"
          e.color = permissions_config['embed_color']
        end
        nil
      end

      command(
        %s(perm.add), min_args: 2,
        permitted_roles: [],
        description: 'Give a role/roles permission to use a command',
        usage: 'perm.add <command> <role/roles>'
      ) do |event, command, *roles|
        db = SQLite3::Database.new 'db/server.db'
        c_exists = db.execute('SELECT EXISTS(SELECT 1 FROM perms '\
                                    'WHERE command = ? LIMIT 1)', command)[0][0]
        break event.respond 'That command doesn\'t exist.' unless c_exists == 1
        role_array = db.execute('SELECT roles FROM perms WHERE command = ?', command)[0][0]
        role_array = role_array.split(',').map(&:to_i) unless role_array.nil?
        role_array = [] if role_array.nil?
        output = ''
        good_output = ''
        roles.each do |role|
          next event.respond 'You have to add roles, and not users.' unless event.server.member(role.to_i).nil?
          role_id = role.to_i
          role_object = event.server.role(role_id)
          good_output += "-#{role_object.name}\n" unless role_array.include?(role_id)
          output += "-#{role_object.name}\n" if role_array.include?(role_id)
          role_array << role.to_i unless role_array.include?(role_id)
        end
        db.execute('UPDATE perms SET roles = (?) WHERE command = (?)', role_array.join(','), command) unless role_array.empty?

        output = 'N/A' unless output != ''
        good_output = 'N/A' unless good_output != ''

        event.channel.send_embed do |e|
          e.thumbnail = { url: permissions_config['embed_image'] }
          e.description = 'The following changes were made:'
          e.add_field name: 'Granted:', value: good_output, inline: true
          e.add_field name: 'Already Exists:', value: output, inline: true
          e.color = permissions_config['embed_color']
        end
        nil
      end

      command(
        %s(perm.remove), min_args: 2,
        permitted_roles: [],
        description: 'Remove permissions from a command.',
        usage: 'perm.remove <command> <role1> <role2> <role3> <role4>'
      ) do |event, command, *roles|
        db = SQLite3::Database.new 'db/server.db'
        c_exists = db.execute('SELECT EXISTS(SELECT 1 FROM perms '\
                              'WHERE command = ? LIMIT 1)', command)[0][0]
        break event.respond 'That command doesn\'t exist.' unless c_exists == 1
        role_array = db.execute('SELECT roles FROM perms '\
                                'WHERE command = ?', command)[0][0]
        break 'There are no permitted roles for this command' if role_array.nil?
        role_array = role_array.split(',').map(&:to_i) unless role_array.nil?

        output = ''
        good_output = ''
        roles.each do |role|
          next event.respond 'You have to add roles, and not users.' unless event.server.member(role.to_i).nil?
          role_id = role.to_i
          role_object = event.server.role(role_id)
          good_output += "-#{role_object.name}\n" if role_array.include?(role_id)
          output += "-#{role_object.name}\n" unless role_array.include?(role_id)
          role_array -= [role_id]
        end
        db.execute('UPDATE perms SET roles = (?) WHERE command = (?)', role_array.join(','), command)

        output = 'N/A' unless output != ''
        good_output = 'N/A' unless good_output != ''

        event.channel.send_embed do |e|
          e.thumbnail = { url: permissions_config['embed_image'] }
          e.description = 'The following changes were made:'
          e.add_field name: 'Revoked:', value: good_output, inline: true
          e.add_field name: 'Not Found:', value: output, inline: true
          e.color = permissions_config['embed_color']
        end
        nil
      end
    end
  end
end
