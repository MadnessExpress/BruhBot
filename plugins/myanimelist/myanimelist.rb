module BruhBot
  module Plugins
    # Myanimelist lookup plugin
    module Myanimelist
      require 'myanimelist'
      require "#{__dir__}/regexmap.rb"
      extend Discordrb::Commands::CommandContainer

      MyAnimeList.configure do |config|
        config.username = BruhBot.api['myanimelist_user']
        config.password = BruhBot.api['myanimelist_pass']
      end

      if File.exist?('plugins/update.txt') &&
         BruhBot::Plugins.const_defined?(:Permissions)
        db = SQLite3::Database.new 'db/server.db'
        db.execute('INSERT OR IGNORE INTO perms (command) '\
                   'VALUES (?), (?)', 'anime', 'manga')
      end

      command(
        :anime, min_args: 1,
        permitted_roles: [],
        desc: 'Search for an anime.',
        usage: 'anime <search terms>'
      ) do |event, *query|
        anime = MyAnimeList.search_anime(query.join(' '))[0]
        break event << 'No results found' if anime.nil?

        re = Regexp.new(REGEXMAP.keys.join('|'))

        anime.each_pair do |key, value|
          anime[key] = value.gsub(re, REGEXMAP) unless value.nil?
        end

        japtitle = anime['title']
        engtitle = anime['english']
        status = anime['status']
        episodes = anime['episodes']
        score = anime['score']
        type = anime['type']
        image = anime['image']
        start = anime['start_date']
        finish = anime['end_date']
        synopsis = anime['synopsis']

        event.channel.send_embed do |e|
          e.title = "English Title: #{engtitle}/ Japanese Title: #{japtitle}"
          e.description = synopsis
          e.thumbnail = { url: image }
          e.add_field name: 'Status', value: status, inline: true
          e.add_field name: 'Air Dates', value: "#{start} to #{finish}",\
                      inline: true
          e.add_field name: 'Score', value: score, inline: true
          e.add_field name: 'Episodes', value: episodes, inline: true
          e.add_field name: 'Type', value: type, inline: true
          e.color = '206D84'
        end
      end

      command(
        :manga, min_args: 1,
        permitted_roles: [],
        desc: 'Search for a Manga.',
        usage: 'manga <search terms>'
      ) do |event, *query|
        manga = MyAnimeList.search_manga(query.join(' '))[0]
        break event << 'No results found' if manga.nil?
        re = Regexp.new(REGEXMAP.keys.join('|'))

        manga.each_pair do |key, value|
          manga[key] = value.gsub(re, REGEXMAP) unless value.nil?
        end

        japtitle = manga['title']
        engtitle = manga['english']
        status = manga['status']
        volumes = manga['volumes']
        score = manga['score']
        image = manga['image']
        start = manga['start_date']
        finish = manga['end_date']
        synopsis = manga['synopsis']

        event.channel.send_embed do |e|
          e.title = "English Title: #{engtitle}/ Japanese Title: #{japtitle}"
          e.description = synopsis
          e.thumbnail = { url: image }
          e.add_field name: 'Status', value: status, inline: true
          e.add_field name: 'Run Dates', value: "#{start} to #{finish}",\
                      inline: true
          e.add_field name: 'Score', value: score, inline: true
          e.add_field name: 'Volumes', value: "#{volumes}\n\n\n\n\n",\
                      inline: true
          e.color = '206D84'
        end
      end
    end
  end
end
