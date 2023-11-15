require "droplet_kit"

module FocusDoDb
  class DatabaseClient
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def add_current_ip
      firewall_rules = do_client.databases.list_firewall_rules(id: config.db_id)

      firewall_rules.push DropletKit::DatabaseFirewallRule.new(
        type: "ip_addr",
        value: public_ip
      )

      puts "Adding IP #{public_ip} to firewall"
      do_client.databases.set_firewall_rules(firewall_rules, id: config.db_id)
    end

    def remove_current_ip
      firewall_rules = do_client.databases.list_firewall_rules(id: config.db_id)

      firewall_rules.delete_if do |rule|
        rule.type == "ip_addr" && rule.value == public_ip
      end

      puts "Removing IP #{public_ip} from firewall"
      do_client.databases.set_firewall_rules(firewall_rules, id: config.db_id)
    end

    def get_connection_string
      cluster = do_client.databases.find_cluster(id: config.db_id)
      db_user = cluster.users.find {|u| u.name == "doadmin" }

      username = db_user.name
      password = db_user.password
      host = cluster.connection.host
      port = cluster.connection.port
      database_name = config.database_name

      "mysql2://#{username}:#{password}@#{host}:#{port}/#{database_name}?ssl-mode=REQUIRED"
    end

    private

    def do_client
      @do_client ||= DropletKit::Client.new(access_token: config.do_api_key)
    end

    def public_ip
      @public_ip ||= Net::HTTP.get(URI('https://api.ipify.org'))
    end
  end
end
