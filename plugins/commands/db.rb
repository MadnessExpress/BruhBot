module Db

  extend Discordrb::Commands::CommandContainer

  command(:db, min_args: 1, description: "Manage database.") do |event, action|

    if (action == "setup") #&& (event.user.id == event.server.owner.id)

      db = SQLite3::Database.new "db/#{event.server.name}.db"

      db.execute <<-SQL
        create table authusers (
          name varchar(30),
          permlevel int
        );
      SQL

      event << "Database has been set up."

    elsif (action == "view")

      db = SQLite3::Database.new "db/#{event.server.name}.db"
    
      db.execute( "select name from sqlite_master where type='table'" ) do |row|

        event << row

      end
 
    else

      event << "You are not the server owner."
    
    end

  end

end
