@export = ["Choose"]
module Choose

  extend Discordrb::Commands::CommandContainer

  command(:choose, min_args: 2, description: 'Make the bot choose something randomly.', usage: 'choose <choice>, <choice>') do |event, *choices|

    #Load config file
    data = YAML::load_file(File.join(__dir__, 'config/choose-config.yml'))

    #Output a message from the choicemessage array in the config file, and insert a random choice from the ones provided
    event.respond data["choicemessage"].sample % {:choice=> choices.join(" ").split(", ").sample}

  end

end
