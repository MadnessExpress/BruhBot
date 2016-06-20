#module CleverbotPlugin

  #extend Discordrb::EventContainer

  #On bot mention.
  #mention do |event|

    #Load config file
    #apidata = YAML::load_file(File.join(__dir__, '../../apikeys.yml'))

    #Connect to Cleverbot
    #cleverbot = Cleverbot.new(apidata["cleverapiuser"], apidata["cleverapikey"])

    #event << cleverbot.say(event.message.content.gsub(/@186576354186100748>/, ""))

    #Sumbit message to Cleverbot minus the mention and output the response.
    #event << cleverbot.say(event.message.content.split("@186576354186100748").map(&:strip)

    #message = event.message.content.split(" <@192334740651638784>" || "<@192334740651638784> ")
    
    #message.delete("<@192334740651638784> ")

    #message = message.join(' ')

    #event << message

  #End bot mention event.
  #end

#End CleverbotPlugin module
#end
