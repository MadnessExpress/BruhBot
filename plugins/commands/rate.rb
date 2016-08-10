@export = ["Rate"]
module Rate

  extend Discordrb::Commands::CommandContainer

  command(:rate, min_args: 1, description: "Rate things!", usage: "rate <stuff>") do |event, *text|

    event.respond "I give #{text.join(" ")} a #{rand(0.0..10.0).round(1)}/10.0!"

  end

end
