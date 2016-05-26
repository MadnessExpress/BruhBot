module Reactions

  extend Discordrb::Commands::CommandContainer

  command(:smug , description: 'Shows a random smug reaction picture') do |event|
    event.respond smug.sample
  end

end
