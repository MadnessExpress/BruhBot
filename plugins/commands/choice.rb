module Choice

  extend Discordrb::Commands::CommandContainer

  command(:choose, min_args: 2, description: 'Make the bot choose something randomly.', usage: 'choose <choice>, <choice>') do |event, *text|

    choices = text.join(' ')

    choicearray = choices.split(', ')

    $choice_choice = choicearray.sample

    event.respond choicemessage.sample

  end

end
