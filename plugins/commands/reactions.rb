module Reactions

  data = YAML::load_file(File.join(__dir__, 'config/reactions-config.yml'))

  extend Discordrb::Commands::CommandContainer

  command(:smug , description: 'Shows a random smug reaction picture') do |event|

    smug = data["smug"].sample

    event.respond smug

  end

end
