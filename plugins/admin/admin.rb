module BruhBot
  module Plugins
    # Admin commands plugin
    module Admin
      extend Discordrb::Commands::CommandContainer

      # Load config file
      admin_conf = Yajl::Parser.parse(File.new("#{__dir__}/config.json", 'r'))

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute(
          'INSERT OR IGNORE INTO perms (command) '\
          'VALUES (?), (?), (?), (?), (?), (?), (?), (?)',
          'update', 'restart', 'shutdown', 'nick',
          'nick.user', 'game', 'clear', 'roles'
        )
        db.close if db

      elsif BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        update_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'update'
        )[0][0]
        update_roles = update_string.split(',').map(&:to_i) unless update_string.nil? # else update_roles = []

        restart_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'restart'
        )[0][0]
        restart_roles = restart_string.split(',').map(&:to_i) unless restart_string.nil? # else shutdown_roles = []

        shutdown_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'shutdown'
        )[0][0]
        shutdown_roles = shutdown_string.split(',').map(&:to_i) unless shutdown_string.nil? # else shutdown_roles = []

        nick_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'nick'
        )[0][0]
        nick_roles = nick_string.split(',').map(&:to_i) unless nick_string.nil? # else shutdown_roles = []

        nickuser_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'restart'
        )[0][0]
        nickuser_roles = nickuser_string.split(',').map(&:to_i) unless nickuser_string.nil? # else shutdown_roles = []

        game_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'restart'
        )[0][0]
        game_roles = game_string.split(',').map(&:to_i) unless game_string.nil? # else shutdown_roles = []

        clear_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'restart'
        )[0][0]
        clear_roles = clear_string.split(',').map(&:to_i) unless clear_string.nil? # else shutdown_roles = []

        roles_string = db.execute(
          'SELECT roles FROM perms WHERE command = ?', 'restart'
        )[0][0]
        roles_roles = roles_string.split(',').map(&:to_i) unless roles_string.nil? # else shutdown_roles = []
      end
      ##########################################################################

      command(
        :update, min_args: 0, max_args: 0,
        permitted_roles: update_roles,
        description: 'Update the bot.',
        usage: 'update'
      ) do |event|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.respond 'Updating and restarting!'
        exec('update.sh')
      end

      command(
        :restart, min_args: 0, max_args: 0,
        permitted_roles: restart_roles,
        description: 'Restart the bot.',
        usage: 'restart'
      ) do |event|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.respond 'Restarting!'
        exec("#{File.expand_path File.dirname(__FILE__)}/update.sh restart")
      end

      command(
        :shutdown,
        permitted_roles: shutdown_roles,
        help_available: false
      ) do |event|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.respond admin_conf['shutdownmessage'].sample
        event.bot.stop
      end

      command(
        :nick, min_args: 1,
        permitted_roles: nick_roles,
        description: 'Change your nickname.',
        usage: 'nick <text>'
      ) do |event, *nick|
        nick = nick.join(' ')
        event.bot.member(event.server.id, event.user.id).nick = nick
        nil
      end

      command(
        %s(nick.user), min_args: 2,
        permitted_roles: nickuser_roles,
        description: 'Change a user\'s nickname.',
        usage: 'nick <user id> <text>'
      ) do |event, userid, *nick|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        nick = nick.join(' ')
        event.bot.member(event.server.id, userid).nick = nick
        nil
      end

      command(
        :game, min_args: 1,
        permitted_roles: game_roles,
        description: 'sets bot game'
      ) do |event, *game|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.bot.game = game.join(' ')
        nil
      end

      command(
        :clear, min_args: 1, max_args: 1,
        permitted_roles: clear_roles,
        description: 'Prune X messages from channel'
      ) do |event, number|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.message.delete
        break event.respond('Please enter a valid number.') if /\A\d+\z/.match(number).nil?
        event.channel.prune(number.to_i)
        stuff = event.respond("[#{number.to_i}] messages cleared.").id
        sleep 5
        event.channel.load_message(stuff).delete
      end

      command(
        :roles, min_args: 0, max_args: 0,
        permitted_roles: [],
        description: 'Get info on all the roles on the server.'
      ) do |event|
        roles = event.server.roles
        output = '```'
        roles.each do |role|
          output += "Name:#{role.name}, ID:#{role.id}, "\
                    "Permissions:#{role.permissions.bits}\n"
          next if output.length < 1800
          output += '```'
          event.user.pm(output)
          output = '```'
        end
        output += '```'
        event.user.pm(output)
        nil
      end
    end
  end
end
