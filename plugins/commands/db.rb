module Db

  extend Discordrb::Commands::CommandContainer

  command(:register, min_args: 0, max_args: 0, description: "Allows users to register themselves in the database with a permission level of 0") do |event|

    db = SQLite3::Database.new "db/#{event.server.id}.db"

    db.execute("INSERT OR IGNORE INTO authusers (userid, name, permlevel) VALUES (?, ?, ?)", [event.user.username, event.user.userid, "0"])

    event << "You have successfully registered."

  end

  command(:db, min_args: 1, description: "Manage database.") do |event, action|

    if (action == "setup") #&& (event.user.id == event.server.owner.id)

      db = SQLite3::Database.new "db/#{event.server.id}.db"

      db.execute <<-SQL
        create table if not exists authusers (
          userid int,
          name varchar(30),
          permlevel int,
          UNIQUE(userid)
        );
      SQL

      db.execute <<-SQL
        create table if not exists quotes (
          quote text,
          UNIQUE(quote)
        );          
      SQL

      db.execute <<-SQL
        create table if not exists cmdperms (
          permname varchar(30),
          permlevel int,
          UNIQUE(permname)
        );
      SQL

      db.execute("INSERT INTO authusers (userid, name, permlevel) VALUES (?, ?, ?)", [event.server.owner.id, event.server.owner.name,"10"])

      db.execute("INSERT INTO cmdperms (permname, permlevel) VALUES (?, ?)", ["quoteadd", "0"])

      event << "Database has been set up, and you have been added with the highest permissions."

    elsif (action == "view")

      db = SQLite3::Database.new "db/#{event.server.id}.db"
    
      db.execute( "select name from sqlite_master where type='table'" ) do |row|

        event << row

      end
 
    else

      event << "You are not the server owner."
    
    end

  end

end
