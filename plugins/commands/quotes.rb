module Quotes

  require_relative("../../requiredmodules.rb")

  extend Discordrb::Commands::CommandContainer

  command(:quoteadd, min_args: 1, description: "Display a random quote.", usage: "quote") do |event, *text|

    event.message.delete

    #Load config file
    data = YAML::load_file(File.join(__dir__, "config/quotes-config.yml"))

    #Load database
    db = SQLite3::Database.new "db/#{event.server.id}.db"

    userauth = Required::Auth.new

    userauth.auth(data["adminroles"], event.server.roles, event.user)

    if (userauth.adminuser == true)

      begin

        db.execute("INSERT INTO quotes (quote) VALUES (?)", [text.join(" ")])

      rescue SQLite3::Exception => e 
    
        event.respond "That quote already exists."
   
        db.close if db

        break

      end

      db.close if db

      event.respond "The quote: #{text.join(" ")}: was added to the database by #{event.user.username}."

    else

      db.close if db

      event.respond "Failed"

    end

  end

  command(:quote, min_args: 0, max_args: 0, description: "Output a random quote.", usage: "quote") do |event|

    #Load database
    db = SQLite3::Database.new "db/#{event.server.id}.db"

    rows = db.execute( "SELECT quote FROM quotes" )

    event.respond rows.sample.sample

  end    

end
