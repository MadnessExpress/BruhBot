module Owner

  extend Discordrb::Commands::CommandContainer

  command(:update, min_args: 0, max_args: 0, description: "Update the bot.", usage: "update") do |event|

    data = YAML::load_file(File.join(__dir__, "config/ownerid.yml"))

    break unless data["ownerid"].include? event.user.id

    event.respond "Updating and restarting!"

    event.bot.stop && exec(File.join(__dir__, "../../update.sh"))

  end

  command(:shutdown, help_available: false) do |event|
  
    data = YAML::load_file(File.join(__dir__, "config/ownerid.yml"))

    break unless data["ownerid"].include? event.user.id

    data = YAML::load_file(File.join(__dir__, "config/owner-config.yml"))

    event.respond "#{data["shutdownmessage"].sample}"

    event.bot.stop

  end

  command(:game,  min_args: 1, description: "sets bot game") do |event, *game|  

    data = YAML::load_file(File.join(__dir__, "config/ownerid.yml"))

    break unless data["ownerid"].include? event.user.id
  
    event.bot.game = game.join(" ")
    
    nil

  end

end
