module Owner

  extend Discordrb::Commands::CommandContainer

  command(:update, min_args: 0, max_args: 0, description: "Update the bot.", usage: "update") do |event|

    break unless event.user.id == 70979549097103360

    event.respond "Updating and restarting!"

    event.bot.stop && exec(File.join(__dir__, "../../update.sh"))

  end

end
