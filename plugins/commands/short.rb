module Short

  extend Discordrb::Commands::CommandContainer

  command(:short, min_args: 1, max_args: 1, description: "Shorten a URL with Googl.", usage: "short <URL>") do |event, url|

    event.message.delete

    apidata = YAML::load_file(File.join(__dir__, "../../apikeys.yml"))

    url = Googl.shorten(url, apidata["googlip"], apidata["googlapikey"])

    event.respond url.short_url

  end

end
