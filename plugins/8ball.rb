module Eightball

  extend Discordrb::EventContainer

  message(containing: "#{commandprefix}8ball") do |event|

    event.respond eightball.sample

  end

end
