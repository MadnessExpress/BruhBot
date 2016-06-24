module Quotes

  extend Discordrb::Commands::CommandContainer

  command(:quoteadd, min_args: 1, description: "Display a random quote.", usage: "quote") do |event, *text|

    #Load config file
    #data = YAML::load_file(File.join(__dir__, "config/quotes.yml"))

    #Load database
    db = SQLite3::Database.new "db/#{event.server.id}.db"

    if (db.execute("SELECT permlevel FROM authusers WHERE userid = #{event.user.id}") == db.execute("SELECT permlevel FROM cmdperms WHERE quoteadd = permname"))

      db.execute("INSERT INTO quotes (quote) VALUES (?)", [text.join(" ")])

      event << "The quote: #{text.join(" ")}: was added to the database."

    else

      event << "Failed"

    end

  end

end
