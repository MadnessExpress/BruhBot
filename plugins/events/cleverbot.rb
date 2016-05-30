module CleverbotPlugin

  extend Discordrb::EventContainer

  cleverbot = Cleverbot.new(cleverapiuser, cleverapikey)

  mention do |event|

    message = event.message.content.gsub(/<@186576354186100748>/, '')

    event.respond cleverbot.say(message)

  end

end
