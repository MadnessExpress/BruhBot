@export = ["CleverbotPlugin"]
module CleverbotPlugin

  extend Discordrb::EventContainer

  #On bot mention.
  mention do |event|

    #Connect to Cleverbot
    cleverbot = RubyCleverbot.new()

    #Sumbit message to Cleverbot minus the mention and output the response.
    event.respond(cleverbot.send_message(event.message.content.gsub(/<@!?\d+>/, "")))

  #End bot mention event.
  end

#End CleverbotPlugin module
end
