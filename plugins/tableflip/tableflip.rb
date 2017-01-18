module BruhBot
  module Plugins
    # Plugin to fix flipped tables
    module Tableflip
      extend Discordrb::EventContainer

      message(with_text: '(╯°□°）╯︵ ┻━┻') do |event|
        event.respond '┬─┬﻿ ノ( ゜-゜ノ)'
      end
    end
  end
end
