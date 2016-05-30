module Say

  extend Discordrb::Commands::CommandContainer

  command(:say, min_args: 1, description: 'Make the bot say stuff.', usage: 'say <stuff>') do |event, *text|

    message = text.join(' ')

    event.message.delete

    event.respond message

  end

end
