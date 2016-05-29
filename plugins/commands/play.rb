module Play

  extend Discordrb::Commands::CommandContainer

  command(:play, min_args: 2, description: 'Invite groups to play a game.', usage: 'play <gamename>, <groupname>') do |event, *text|

    #Convert array into a string putting a space between indexes.
    info = text.join(' ')

    #Convert string back into array separating game name and groups/people with a comma.
    infoarray = info.split(", ")

    #Assign global variables.
    $play_gamename = infoarray[0]
    $play_groupname = infoarray[1]
    $play_user = event.user.username

    #Output a random message from the play message section of the config.
    event.respond playmessage.sample

  end

end
