@export = ["Rps"]
module Rps

  extend Discordrb::Commands::CommandContainer

  command(:rps, min_args: 1, description: "Play rock, paper, scissors with the bot.", usage: "rps rock, rps paper, or rps scissors") do |event|

    #Load config file
    data = YAML::load_file(File.join(__dir__, "config/rps-config.yml"))

    #Output a message with a randomly selected message from the config and insert a random option from the config.
    event.respond data["messages"].sample % {:option=> data["options"].sample}

  end

end
