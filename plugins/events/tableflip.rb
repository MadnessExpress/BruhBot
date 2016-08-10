@export = ["Tableflip"]
module Tableflip

  extend Discordrb::EventContainer

  #message(with_text: '┬─┬﻿ ノ( ゜-゜ノ)') do |event|
  #  event.respond '(╯°□°）╯︵ ┻━┻'
  #end

  message(with_text: '(╯°□°）╯︵ ┻━┻') do |event|
    event.respond '┬─┬﻿ ノ( ゜-゜ノ)'
  end

end
