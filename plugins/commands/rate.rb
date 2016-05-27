module Rate

  extend Discordrb::Commands::CommandContainer

  command(:rate, min_args: 1, description: 'Rate things!', usage: 'rate <stuff>') do |event, text|

    rating = rand(0.0..10.0)

    event.respond "I give #{text} a #{rating.round(1)}/10.0!"

  end

end
