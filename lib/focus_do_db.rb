require 'focus_do_db/config'
require 'focus_do_db/database_client'

module FocusDoDb
  class Engine < Rails::Engine
    initializer "active_record.initialize_timezone" do |app|
      config = Config.new
      if config.enabled?
        puts "Engine initializing!"
        puts "Using DO Key: #{config.do_api_key}"
        puts "Access database: #{config.db_id}"

        db = DatabaseClient.new(config)
        db.add_current_ip
        ENV['DATABASE_URL'] = db.get_connection_string
      end
    end

    at_exit do
      config = Config.new
      if config.enabled?
        puts "Engine unloading!"
        db = DatabaseClient.new(config)
        db.remove_current_ip
      end
    end
  end
end
