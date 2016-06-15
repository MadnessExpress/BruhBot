module Msg

  extend Discordrb::Commands::CommandContainer

  command(:msg, min_args: 2, description: "Send a message to another channel.", usage: "msg <channel name> <message> --srv <servername>") do |event, channel, *message|

    #Turns message into string.
    message = message.join(' ')

    messagearray = message.split('--srv').map(&:strip)

    message = messagearray[0]

    servername = messagearray[1]

    #Gets array of matching channels.
    channelarray = event.bot.find_channel(channel, servername)

    #Gets the first array result for channel id.
    channelid = channelarray[0]

    #Sends message to the specified channel.
    event.bot.send_message(channelid, message, tts = false)

  end

end
