@export = ["Paste"]
module Paste

  extend Discordrb::Commands::CommandContainer

  command(:paste, min_args: 1, description: "Creates a Pastebin paste with the specified text.", usage: "paste <text>") do |event, *text|

    apidata = YAML::load_file(File.join(__dir__, '../../apikeys.yml'))

    pastebin = Pastebin::Client.new(apidata["pastebinapikey"])

    event.respond pastebin.newpaste(text.join(" "))

  end

end
