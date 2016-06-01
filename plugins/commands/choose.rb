module Choose

  data = YAML::load_file(File.join(__dir__, 'config/choose-config.yml'))

  extend Discordrb::Commands::CommandContainer

  command(:choose, min_args: 2, description: 'Make the bot choose something randomly.', usage: 'choose <choice>, <choice>') do |event, *text|

    choices = text.join(' ')

    choicearray = choices.split(', ')

    choice = choicearray.sample

    message = data["choicemessage"].sample

    insert = {:choice=> choice}

    event.respond message % insert

  end

end
