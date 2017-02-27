db = SQLite3::Database.new 'db/server.db'

db.execute <<-SQL
  create table if not exists data (
    id int,
    version numeric,
    UNIQUE(id),
    UNIQUE(version)
  );
SQL

query = [
  'ALTER TABLE data ADD COLUMN id int, UNIQUE(id)',
  'ALTER TABLE data ADD COLUMN version numeric, UNIQUE(version)'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

id = 1
version = 1.0
db.execute(
  'INSERT OR IGNORE INTO data (id, version) VALUES (?, ?)', id, version
)

db.close if db
