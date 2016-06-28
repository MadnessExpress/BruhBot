module Play

  extend Discordrb::Commands::CommandContainer

  command(:play, min_args: 2, description: "Invite groups to play a game.", usage: "play <gamename>, <groupname>") do |event, *text|

    event.message.delete

    #Load config file
    data = YAML::load_file(File.join(__dir__, "config/play-config.yml"))

    #Convert array into string and back into an array separating game name and groups/people with a comma.
    infoarray = text.join(" ").split(", ")

    #Assign variables to insert into message
    gamename = infoarray[0]
    groupname = infoarray[1]

    #Output a random message from the play message section of the config and insert the proper variables.
    event.respond data["playmessage"].sample % {:gamename=> ":video_game: #{gamename} :video_game:", :groupname=> groupname, :user=> event.user.username}

  end

end
