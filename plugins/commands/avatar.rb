@export = ["Avatar"]
module Avatar

  extend Discordrb::Commands::CommandContainer

  command(:avatar, min_args: 1, description: "Fetches a user's avatar.") do |event, arg|

    if (arg == "server")

      event.respond event.server.icon_url

    else

      event.respond event.bot.parse_mention(arg).avatar_url

    end

  end

end
