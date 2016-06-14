module Msg

  extend Discordrb::Commands::CommandContainer
  extend Discordrb::Cache
#  extend Discordrb::Bot

  command(:msg, min_args: 2, description: "Send a message to another channel.", usage: "msg <channel name> <message>") do |channel, *message|

    channelarray = find_channel(channel, server_name = nil, type: "text")

    channelid = channelarray[0]

    send_message(channelid, message, tts = false, server_id = nil)

  end

end
