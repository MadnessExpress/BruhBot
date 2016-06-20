module Msg

  extend Discordrb::Commands::CommandContainer

  command(:msg, min_args: 2, description: "Send a message to another channel.", usage: "msg <channel name> <message> --srv <servername>") do |event, channel, *message|

    #Turns message into a string and then splits into an array based on what is after --srv.
    messagearray = message.join(" ").split("--srv").map(&:strip)

    #Gets array of matching channels in the specified server.
    channelarray = event.bot.find_channel(channel, messagearray[1])

    #Sends message to the specified channel in the specified server.
    event.bot.send_message(channelarray[0], messagearray[0], tts = false)

  #End msg command
  end

#end Msg module
end
