module CleverbotPlugin

  apidata = YAML::load_file(File.join(__dir__, '../../apikeys.yml'))

  cleverapiuser = apidata["cleverapiuser"]
  cleverapikey = apidata["cleverapikey"]

  extend Discordrb::EventContainer

  cleverbot = Cleverbot.new(cleverapiuser, cleverapikey)

  mention do |event|

    message = event.message.content.gsub(/<@186576354186100748>/, '')

    event.respond cleverbot.say(message)

  end

end
