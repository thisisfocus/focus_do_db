module FocusDoDb
  class Config
    def initialize
      @config ||= YAML.load_file(Rails.root.join("config/focus_do_db.yml"))
      @db_config ||= YAML.load_file(Rails.root.join("config/database.yml"))
    end

    def enabled?
      database.present?
    end

    def database
      ENV['FOCUS_DO_DB']
    end

    def do_api_key
      ENV[@config["api_env_name"]]
    end

    def db_id
      @config["databases"][database]
    end

    def database_name
      @db_config[Rails.env]["database"]
    end
  end
end
