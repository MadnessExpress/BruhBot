module BruhBot
  module Plugins
    # Lottery plugin
    module Lottery
      extend Discordrb::Commands::CommandContainer

      # The variables below load up when the bot is started so that they
      # can store info outside of the command.

      # Entered users array
      lottousers = []
      # Whether the lottery has started. 0 = No, 1 = Yes
      started = 0
      # The user that started the lottery.
      startuser = ''

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) '\
                   'VALUES (?), (?), (?), (?)', 'lotto.start', 'lotto.enter',
                   'lotto.end', 'lotto.kill')
      end

      command(
        %s(lotto.start), max_args: 0,
        permitted_roles: [],
        description: 'Start a lottery.',
        usage: '!lotto.start'
      ) do |event|
        event.message.delete
        break event.respond 'There is already a lottery in progress.' unless started.zero?
        # Variable showing lottery is started
        started = 1
        # Get user mention for message
        user = event.user.display_name
        # Set user that started the lottery
        startuser = event.user.id
        event.respond "#{user} has started a lottery!"
      end

      command(
        %s(lotto.enter), max_args: 0,
        permitted_roles: [],
        description: 'Enter a lottery.',
        usage: '!lotto.enter'
      ) do |event|
        event.message.delete
        break event.respond 'No lottery running.' unless started == 1
        checkuser = lottousers.include? event.user.id
        break event.respond 'You have already entered the lottery.' unless checkuser == false
        user = event.bot.member(event.server.id, event.user.id).mention

        lottousers << event.user.id
        event.respond "#{user} has entered the lottery."
      end

      command(
        %s(lotto.end), max_args: 0,
        permitted_roles: [],
        description: 'End a lottery.',
        usage: '!lotto.end'
      ) do |event|
        event.message.delete
        break event << 'No lottery running.' unless started == 1 &&
                                                    startuser == event.user.id

        started = 0
        winner = event.bot.member(event.server.id, lottousers.sample).mention
        lottousers = []
        startuser = ''

        event.respond "The lottery has ended and #{winner} is the winner!" unless winner.nil?
        event.respond 'The lottery has ended' if winner.nil?
      end

      command(
        %s(lotto.kill), max_args: 0,
        permitted_roles: [],
        description: 'Kill a lottery.',
        usage: '!lotto.kill'
      ) do |event|
        event.message.delete
        break unless BruhBot.conf['owners'].include? event.user.id
        break event.respond 'No lottery to kill.' unless started == 1

        started = 0
        lottousers = []
        event.respond "#{event.user.mention} has killed this lottery"
      end
    end
  end
end
