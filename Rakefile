require './environment'

ROOT_PATH = File.expand_path "..", __FILE__
MIGRATIONS_PATH = File.join ROOT_PATH, "db", "migrate"

namespace :db do
  task :gen_migration, [:migration_name] do |_t, args|
    migration_name = args.fetch :migration_name
    migration_name_words = migration_name.split(/\s+/)
    migration_class_name = migration_name_words.map(&:capitalize).join + "Migration"
    migration_file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_" + migration_name_words.join("_").downcase + ".rb"
    migration_file_path = File.join MIGRATIONS_PATH, migration_file_name

    FileUtils.mkdir_p(MIGRATIONS_PATH)
    File.open(migration_file_path, "w") do |migration_file|
      migration_file.write <<~RB
        class #{migration_class_name}
          def up
          end

          def down
          end
        end
      RB
    end
  end

  task :migrate do
    migration_file_paths = Dir[File.join(MIGRATIONS_PATH, "*.rb")].sort

    current_schema_version = DB[:schema_migrations].first[:version]
    if !current_schema_version.nil?
      path = ""
      while !path.include?(current_schema_version)
        path = migration_file_paths.shift
      end
    end

    if migration_file_paths.empty?
      raise "Nothing to do."
    end

    migration_file_paths.each do |migration_file_name|
      expected_migration_class_name = migration_file_name
        .split(File::SEPARATOR)
        .last
        .sub(/^\d+_/, "")
        .sub(/.rb$/, "")
        .split("_")
        .map(&:capitalize)
        .join + "Migration"

      require migration_file_name
      Object.const_get(expected_migration_class_name).new.up
    end

    new_schema_version = migration_file_paths.last.split(File::SEPARATOR).last.match(/^\d+/)[0]

    DB[:schema_migrations].update(version: new_schema_version)
  end

  task :create do
    db_name = ENV.fetch "DATABASE_NAME", "phax_machine"
    Sequel.connect(adapter: "postgres", database: "postgres", user: ENV["DATABASE_USER"], password: ENV["DATABASE_PASSWORD"]) do |db|
      db.execute "DROP DATABASE IF EXISTS #{db_name}"
      db.execute "CREATE DATABASE #{db_name}"
    end
    DB.create_table(:schema_migrations) { String :version }
    DB[:schema_migrations].insert(version: nil)
  end
end
