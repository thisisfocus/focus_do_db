require 'focus_do_db/config'
require 'focus_do_db/database_client'
require 'focus_do_db/log'

module FocusDoDb
  class Engine < Rails::Engine
    initializer "active_record.initialize_timezone" do |app|
      config = Config.new
      if config.enabled?

        Log.print ""
        Log.print "Focus DO DB Initialising!"
        Log.print "========================="
        Log.print ""
        Log.print "Using DB Access : #{config.database} (#{config.db_id})"
        Log.print "Using DO Key    : #{config.do_api_key.try(:first, 13)} (...)"
        Log.print ""

        db = DatabaseClient.new(config)

        Log.print "Adding IP to DB : #{db.public_ip}"
        Log.print ""

        db.add_current_ip
        ENV['DATABASE_URL'] = db.get_connection_string

        Log.print "Complete - you now have #{config.database.to_s.upcase} access to #{Rails.env.to_s.upcase} data"
        Log.print ""
        Log.print "*** Please Be Careful! ***"
        Log.print ""
      end
    end

    at_exit do
      config = Config.new
      if config.enabled?

        Log.print ""
        Log.print "Focus DO DB Unloading!"
        Log.print ""

        db = DatabaseClient.new(config)

        Log.print "Removing IP from DB: #{db.public_ip}"
        Log.print ""

        db.remove_current_ip

        Log.print "Exiting ..."
        Log.print ""
      end
    end
  end
end
