@export = ["Db"]
module Db

  extend Discordrb::Commands::CommandContainer

  command(:db, min_args: 0, max_args: 0, description: "Manage database.") do |event|

    data = YAML::load_file(File.join(__dir__, "config/ownerid.yml"))

    break unless (event.user.id == event.server.owner.id) || (data["ownerid"].include? event.user.id)

    Dir.mkdir("db") unless File.exists?("db")
    Dir.mkdir("logs") unless File.exists?("logs")
    Dir.mkdir("logs/commandlogs") unless File.exists?("logs/commandlogs")
    Dir.mkdir("logs/messagelogs") unless File.exists?("logs/messagelogs")

    db = SQLite3::Database.new "db/#{event.server.id}.db"

    db.execute <<-SQL
      create table if not exists quotes (
        quote text,
        UNIQUE(quote)
      );          
    SQL

    event.respond "Database has been set up."

  end

end
