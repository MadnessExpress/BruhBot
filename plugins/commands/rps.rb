module Rps

  data = YAML::load_file(File.join(__dir__, 'config/rps-config.yml'))

  extend Discordrb::Commands::CommandContainer

  command(:rps, min_args: 1, description: 'Play rock, paper, scissors with the bot.', usage: 'rps rock, rps paper, or rps scissors') do |event|

    option = data["options"].sample

    message = data["messages"].sample

    insert = {:option=> option}

    event.respond message % insert

  end

end
