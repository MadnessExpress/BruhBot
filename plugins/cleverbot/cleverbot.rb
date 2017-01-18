module BruhBot
  module Plugins
    # Cleverbot plugin
    module CleverbotPlugin
      require 'ruby_cleverbot'

      extend Discordrb::EventContainer

      # On bot mention.
      mention do |event|
        # Connect to Cleverbot
        cleverbot = RubyCleverbot.new

        # Scrubbed message
        message = event.message.content.gsub(/<@192334740651638784>/, '')
        message = message.gsub(/<@!192334740651638784>/, '')
        message = message.gsub(/<@!?(\d+)>/) do
          event.bot.user(Regexp.last_match(1).to_i.to_i).on(event.server).display_name
        end

        # Sumbit message to Cleverbot minus the mention and output the response.
        event.respond cleverbot.send_message(message)
      end
      # End bot mention event.
    end
    # End CleverbotPlugin module
  end
end
