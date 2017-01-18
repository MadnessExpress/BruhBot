module BruhBot
  module Plugins
    # Currency plugin
    module Currency
      extend Discordrb::EventContainer
      extend Discordrb::Commands::CommandContainer

      require 'rounding'

      currency_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      if BruhBot.conf['first_run'] == 1
        BruhBot.bot.ready do |event|
          db = SQLite3::Database.new 'db/server.db'
          event.bot.servers.keys.each do |s|
            event.bot.server(s).members.each do |m|
              db.execute('INSERT OR IGNORE INTO levels (userid, level, xp) '\
                         'VALUES (?, ?, ?)', [m.id, 1, 0])
            end
          end
          db.close if db
        end
      end
################################################################################

      if File.exist?('plugins/update.txt') && BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'

        db.execute <<-SQL
          create table if not exists currency (
            userid int,
            amount int,
            UNIQUE(userid)
          );
        SQL

        db.execute('INSERT OR IGNORE INTO perms (command) '\
                   'VALUES (?), (?), (?)', 'money', 'money.give', 'money.add')

      elsif BruhBot.conf['first_run'] == 1
        db = SQLite3::Database.new 'db/server.db'

        db.execute('INSERT OR IGNORE INTO currency (userid, amount) '\
                   'VALUES (?, ?)', event.user.id, 100)
      end
################################################################################

      message do |event|
        unless event.channel.private?
          db = SQLite3::Database.new 'db/server.db'
          db.execute('INSERT OR IGNORE INTO currency (userid, amount) '\
                     'VALUES (?, ?)', event.user.id, 100)

          amount = db.execute('SELECT amount FROM currency '\
                              'WHERE userid = (?)', event.user.id)[0][0]
          mlength = event.message.content.length.round_to(5)
          amount += mlength

          db.execute('UPDATE currency SET amount = (?) '\
                     'WHERE userid = (?)', amount, event.user.id)
          db.close if db
        end
      end



      command(
        :money, max_args: 0,
        permitted_roles: [],
        description: 'See how much money you have.',
        usage: 'money'
      ) do |event|

        break event.respond 'You can\'t use this feature in a dm' if event.channel.private?

        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO currency (userid, amount) '\
                    'VALUES (?, ?)', event.user.id, 100)

        currency = db.execute('SELECT amount FROM currency '\
                              'WHERE userid = (?)', event.user.id)[0][0]
        db.close if db
        displayamount = currency.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{','}")

        event.channel.send_embed do |e|
          e.thumbnail = { url: currency_config['embed_image'] }
          e.description = currency_config['money_message']
          e.add_field name: 'Money:',
                      value: "#{currency_config['currency_symbol']}"\
                             "#{displayamount} "\
                             "#{currency_config['currency_name']}",
                      inline: false
          e.color = currency_config['embed_color']
        end
      end

      command(
        %s(money.give), min_args: 2, max_args: 2,
        permitted_roles: [],
        descriptions: 'Give money to a designated person.',
        usage: 'givemoney <amount> <usermention>'
      ) do |event, amountgiven, user|
        break event.respond 'You can\'t use this feature in a dm' if event.channel.private?
        db = SQLite3::Database.new 'db/server.db'

        currency = db.execute('SELECT amount FROM currency '\
                              'WHERE userid = (?)', event.user.id)[0][0]
        cleanuser = user.gsub(/<@!?(\d+)>/) { |s| event.bot.user($1.to_i).on(event.server).id }
        displayuser = user.gsub(/<@!?(\d+)>/) { |s| event.bot.user($1.to_i).on(event.server).send(currency_config['recipient_name_type']) }

        db.execute('INSERT OR IGNORE INTO currency (userid, amount) '\
                   'VALUES (?, ?)', event.user.id, 100)
        db.execute('INSERT OR IGNORE INTO currency (userid, amount) '\
                   'VALUES (?, ?)', cleanuser, 100)
        db.close if db

        if (event.user.id != cleanuser.to_i) && (currency >= amountgiven.to_i.round_to(5)) && /\A\d+\z/.match(amountgiven) && /\A\d+\z/.match(cleanuser)
          db = SQLite3::Database.new 'db/server.db'

          amount = currency - amountgiven.to_i.round_to(5)

          db.execute('UPDATE currency SET amount = (?) '\
                     'WHERE userid = (?)', amount, event.user.id)

          currency = db.execute('SELECT amount FROM currency '\
                                'WHERE userid = (?)', cleanuser.to_i)[0][0]
          totalamountgiven = currency + amountgiven.to_i.round_to(5)
          db.execute('UPDATE currency SET amount = (?) '\
                     'WHERE userid = (?)', totalamountgiven, cleanuser.to_i)
          displayamount = amountgiven.to_i.round_to(5).to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{','}")
          db.close if db

          mentions = event.message.mentions.map! { |m| m = event.bot.member(event.server.id, m.id).mention }.join(', ')

          event.channel.send_embed(mentions, nil) do |e|
            e.thumbnail = { url: currency_config['embed_image'] }
            e.description = currency_config['money.give_message']
            e.add_field name: 'Amount:',
                        value: "#{currency_config['currency_symbol']}"\
                               "#{displayamount} "\
                               "#{currency_config['currency_name']}",
                        inline: false
            e.add_field name: 'Sender:', value: event.user.mention, inline: true
            e.add_field name: 'Recipient:', value: displayuser, inline: true
            e.color = currency_config['embed_color']
          end

        elsif currency < amountgiven.to_i.round_to(5)
          event.respond('You do not have sufficient funds to do that.')

        elsif /\A\d+\z/.match(amountgiven).nil? ||
              /\A\d+\z/.match(cleanuser).nil?
          event.respond('Please enter a proper number, and make sure you '\
                        'mention the user you want to give it to.')

        elsif event.user.id == cleanuser.to_i
          event.respond("#{displayuser} tried to give themselves money, "\
                        "because #{displayuser} is an idiot")
        end
        nil
      end

      command(
        %s(money.add), min_args: 2, max_args: 2,
        permitted_roles: [],
        descriptions: 'Add money to a designated person.',
        usage: 'givemoney <amount> <usermention>'
      ) do |event, amountgiven, user|
        break event.respond 'You can\'t use this feature in a dm' if event.channel.private?
        break unless BruhBot.conf['owners'].include? event.user.id
        event.message.delete
        db = SQLite3::Database.new 'db/server.db'

        cleanuser = user.gsub(/<@!?(\d+)>/) { |s| event.bot.user($1.to_i).on(event.server).id }
        currency = db.execute('SELECT amount FROM currency '\
                              'WHERE userid = (?)', cleanuser.to_i)[0][0]
        puts currency
        totalamountgiven = currency + amountgiven.to_i.round_to(5)
        db.execute('UPDATE currency SET amount = (?) '\
                   'WHERE userid = (?)', totalamountgiven, cleanuser.to_i)
        db.close if db

        displayuser = user.gsub(/<@!?(\d+)>/) { |s| event.bot.user($1.to_i).on(event.server).send(currency_config['recipient_name_type']) }
        displayamount = amountgiven.to_i.round_to(5).to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{','}")

        mentions = event.message.mentions.map! { |m| m = event.bot.member(event.server.id, m.id).mention }.join(', ')

        event.channel.send_embed(mentions, nil) do |e|
          e.thumbnail = { url: currency_config['embed_image'] }
          e.description = currency_config['money.add_message']
          e.add_field name: 'Amount:',
                      value: "#{currency_config['currency_symbol']}"\
                             "#{displayamount} "\
                             "#{currency_config['currency_name']}",
                             inline: false
          e.add_field name: 'Admin:', value: event.user.mention, inline: true
          e.add_field name: 'Recipient:', value: displayuser, inline: true
          e.color = currency_config['embed_color']
        end
      end
    end
  end
end
