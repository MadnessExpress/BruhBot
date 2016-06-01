module Play

  data = YAML::load_file(File.join(__dir__, 'config/play-config.yml'))

  extend Discordrb::Commands::CommandContainer

  command(:play, min_args: 2, description: 'Invite groups to play a game.', usage: 'play <gamename>, <groupname>') do |event, *text|

    #Convert array into a string putting a space between indexes.
    info = text.join(' ')

    #Convert string back into array separating game name and groups/people with a comma.
    infoarray = info.split(", ")

    #Assign global variables.
    gamename = infoarray[0]
    groupname = infoarray[1]
    user = event.user.username

    #Get messages from config
    playmessage = data["playmessage"].sample

    #Shove variables into string.
    input = {:gamename=> gamename, :groupname=> groupname, :user=> user} 

    #Output a random message from the play message section of the config.
    event.respond playmessage % input

  end

end
