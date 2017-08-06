#!/usr/bin/env ruby
require 'sqlite3'

Dir.mkdir('db') unless File.exist?('db')

db = SQLite3::Database.new 'db/server.db'

# Create bandnames table
db.execute <<-SQL
  create table if not exists bandnames (
    name text,
    genre text,
    addedby int,
    UNIQUE(name)
  );
SQL

query = [
  'ALTER TABLE bandnames ADD COLUMN name text, UNIQUE(name)',
  'ALTER TABLE bandnames ADD COLUMN genre text',
  'ALTER TABLE bandnames ADD COLUMN addedby text'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

# Create currency table

db.execute <<-SQL
  create table if not exists currency (
    userid int,
    amount int,
    UNIQUE(userid)
  );
SQL


query = [
  'ALTER TABLE currency ADD COLUMN userid int, UNIQUE(userid)',
  'ALTER TABLE currency ADD COLUMN amount int'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

# Set up levels table
db.execute <<-SQL
    create table if not exists levels (
      userid int,
      level int,
      xp int,
      UNIQUE(userid)
    );
SQL

query = [
  'ALTER TABLE levels ADD COLUMN userid int, UNIQUE(userid)',
  'ALTER TABLE levels ADD COLUMN level int',
  'ALTER TABLE levels ADD COLUMN xp int'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

# Create permissions table
db.execute <<-SQL
  create table if not exists perms (
    command text,
    roles text,
    UNIQUE(command)
  );
SQL

query = [
  'ALTER TABLE perms ADD COLUMN command text, UNIQUE(command)',
  'ALTER TABLE perms ADD COLUMN roles text'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

# Create quotes table
db.execute <<-SQL
  create table if not exists quotes (
    quote text,
    UNIQUE(quote)
  );
SQL

query = [
  'ALTER TABLE quotes ADD COLUMN quote text, UNIQUE(quote)'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

# Set up 8ball in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', '8ball')

# Set up admin in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?), (?), (?), (?), (?), (?), (?)',
  'bot.avatar', 'update', 'restart', 'shutdown', 'nick',
  'nick.user', 'game', 'clear', 'roles'
)

# Set up avatar fetch in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) VALUES (?), (?)',
  'avatar', 'avatar.server'
)

# Set up band names in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?)', 'band', 'band.add', 'band.remove'
)

# Set up choose in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'choose')

# Set up currency in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?)', 'money', 'money.give', 'money.add'
)

# Set up diceroller in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?), (?)', 'roll', 'roll.mod', 'roll.fudge', 'coin'
)

# Set up url shortener in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'short')

# Set up levels in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'level')

# Set up lotto in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?), (?)', 'lotto.start', 'lotto.enter',
  'lotto.end', 'lotto.kill'
)

# Set up myanimelist in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?)', 'anime', 'manga'
)

# Set up pastebin in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'paste')

# Set up permissions in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?), (?)', 'perm',\
  'perm.list', 'perm.add', 'perm.remove'
)

# Set up play in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'play')

# Set up quotes in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?)', 'quote', 'quote.add', 'quote.remove'
)

# Set up rate in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'rate')

# Set up react in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'react')

# Set up rps in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'rps')

# Set up say in roles db
db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?)', 'say', 'say.channel'
)

# Set up wikipedia in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'wiki')

# Set up youtube in roles db
db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'youtube')

db.close if db
