module Eightball

  extend Discordrb::Commands::CommandContainer

  command(%s(8ball), min_args: 1, description: 'Consult the magic 8ball', usage: '8ball <question>') do |event|

    event.respond ":8ball: #{eightball.sample}"

  end

end
