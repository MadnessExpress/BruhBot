module Reactions

  extend Discordrb::Commands::CommandContainer

  command(:smug , description: "Shows a random smug reaction picture") do |event|

    #Load config file
    data = YAML::load_file(File.join(__dir__, "config/reactions-config.yml"))

    #Output a random image link from the config array
    event.respond data["smug"].sample

  end

end
