require "bundler"
Bundler.require

require "json"
require "tempfile"
require "fileutils"

Dotenv.load

if ENV["DATABASE_URL"]
  DB = Sequel.connect(ENV["DATABASE_URL"])
else
  DB = Sequel.connect(
    adapter: "postgres",
    database: ENV.fetch("DATABASE_NAME", "phax_machine"),
    user: ENV["DATABASE_USER"],
    password: ENV["DATABASE_PASSWORD"]
  )
end
