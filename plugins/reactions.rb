module Reactions

  extend Discordrb::Commands::CommandContainer

  smug = ['http://i.imgur.com/3WeW7RK.png', 'http://i.imgur.com/waRuHXo.png', 'http://i.imgur.com/DShJUv2.png']

  command(:smug , description: 'Shows a random smug reaction picture') do |event|
    event.respond "test \n #{smug.sample}"
  end

end
