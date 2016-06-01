module Eightball

  data = YAML::load_file(File.join(__dir__, 'config/8ball-config.yml'))

  extend Discordrb::Commands::CommandContainer

  command(%s(8ball), min_args: 1, description: 'Consult the magic 8ball', usage: '8ball <question>') do |event|

    eightball = data["eightball"].sample

    event.respond ":8ball: #{eightball}"

  end

end
