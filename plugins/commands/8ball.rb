module Eightball

  extend Discordrb::Commands::CommandContainer

  command(%s(8ball), min_args: 1, description: "Consult the magic 8ball", usage: "8ball <question>") do |event|

    #Load config file
    data = YAML::load_file(File.join(__dir__, "config/8ball-config.yml"))

    #Output a random message from the eightball array in the config file.
    event.respond ":8ball: #{data["eightball"].sample}"

  #End of the 8ball command.
  end

#End of the Eightball module.
end
