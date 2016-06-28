module Owner

  extend Discordrb::Commands::CommandContainer

  command(:update, min_args: 0, max_args: 0, description: "Update the bot.", usage: "update") do |event|

    break unless event.user.id == 70979549097103360

    event.respond "Updating and restarting!"

    event.bot.stop && exec(File.join(__dir__, "../../update.sh"))

  end

  command(:shutdown, help_available: false) do |event|
  
    break unless event.user.id == 70979549097103360 # Replace number with your ID

    data = YAML::load_file(File.join(__dir__, "config/owner-config.yml"))

    event.respond "#{data["shutdownmessage"].sample}"

    nil

    event.bot.stop

  end

  command(:game,  min_args: 1, description: "sets bot game") do |event, *game|  
  
    event.bot.game = game.join(' ')
    
    nil

  end

end
