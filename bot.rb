#!/home/atlas/.rbenv/shims/ruby

require 'bundler/setup'
require 'discordrb'
require 'sqlite3'
require 'yajl'

# This is the main bot Module
module BruhBot
  class << self
    attr_accessor :conf
    attr_accessor :api
    attr_accessor :bot
  end

  $LOAD_PATH << File.join(File.dirname(__FILE__))

  self.conf = Yajl::Parser.parse(File.new('config.json', 'r'))
  self.api = Yajl::Parser.parse(File.new('apikeys.json', 'r'))
  self.bot = Discordrb::Commands::CommandBot.new(
    token: api['discord_token'],
    client_id: api['discord_app_id'],
    prefix: conf['prefix']
  )

  Dir.mkdir('db') unless File.exist?('db')
  Dir.mkdir('logs') unless File.exist?('logs')
  Dir.mkdir('logs/commandlogs') unless File.exist?('logs/commandlogs')
  Dir.mkdir('logs/messagelogs') unless File.exist?('logs/messagelogs')

  require 'plugins/permissions/permissions.rb' if File.exist?(
    'plugins/permissions/permissions.rb'
  )

  Dir['plugins/*/*.rb'].each do |file|
    require file unless file == 'plugins/permissions/permissions.rb'
  end

  Plugins.constants.each do |mod|
    bot.include! Plugins.const_get mod
  end

  # Here we output the invite URL to the console so the bot account can be
  # invited to the channel.
  puts "This bot's invite URL is #{bot.invite_url}&permissions=261120"
  puts 'Click on it to invite it to your server.'

  File.delete('plugins/update.txt') if File.exist?('plugins/update.txt')

  conf['first_run'] = 0
  Yajl::Encoder.encode(
    conf, [File.new('config.json', 'w'), { pretty: true, indent: '\t' }]
  )

  bot.run
end
