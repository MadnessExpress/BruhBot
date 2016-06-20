module Say

  extend Discordrb::Commands::CommandContainer

  command(:say, min_args: 1, description: 'Make the bot say stuff.', usage: 'say <stuff>') do |event, *message|

    event.message.delete

    event << message.join(' ')

  end

end
