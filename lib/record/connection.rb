require 'delegate'
begin
  require "oci8"
rescue LoadError => e
  # OCI8 driver is unavailable or failed to load a required library.
  raise LoadError, "ERROR: '#{e.message}'. "\
    "Could not load ruby-oci8 library. "\
    "You may need install ruby-oci8 gem."
end
module  Record
  class Connection
    def initialize(config)
      @config = config
      @raw_connection = OciFactory.new_connection(@config)
    end
    def exec(sql, *bindvars, &block)
       @raw_connection.exec(sql, *bindvars, &block)
    end
    def prepare(sql)
      Cursor.new(self, @raw_connection.parse(sql))
    end
    class Cursor
      def initialize(connection, raw_cursor)
        @connection = connection
        @raw_cursor = raw_cursor
      end
      def exec
        @raw_cursor.exec
      end
      def get_col_names
        @raw_cursor.get_col_names
      end
      def fetch
        @raw_cursor.fetch
      end
      def close
        @raw_cursor.close
      end
    end
    def select(sql,return_column_names = true)
      cursor = @raw_connection.exec(sql)
      cols = []
      # Ignore raw_rnum_ which is used to simulate LIMIT and OFFSET
      cursor.get_col_names.each do |col_name|
        col_name = col_name.downcase
        cols << col_name unless col_name == 'raw_rnum_'
      end
      # Reuse the same hash for all rows
      #column_hash = {}
      #cols.each {|c| column_hash[c] = nil}
      rows = []
      while row = cursor.fetch
        hash = {}
        cols.each_with_index do |col, i|
          hash[col.to_sym] = row[i]
        end
        rows << hash
      end
      return_column_names ? [cols, rows] : rows
      ensure
      cursor.close if cursor
    end
  end
  class OciFactory
    def self.new_connection(config)
      # to_s needed if username, password or database is specified as number in database.yml file
      username = config[:username] && config[:username].to_s
      password = config[:password] && config[:password].to_s
      database = config[:database] && config[:database].to_s
      host, port = config[:host], config[:port]
      privilege = config[:privilege] && config[:privilege].to_sym
      async = config[:allow_concurrency]
      prefetch_rows = config[:prefetch_rows] || 100
      cursor_sharing = config[:cursor_sharing] || 'force'
      # get session time_zone from configuration or from TZ environment variable
      time_zone = config[:time_zone] || ENV['TZ']

      # connection using host, port and database name
      connection_string = if host || port
        host ||= 'localhost'
        host = "[#{host}]" if host =~ /^[^\[].*:/  # IPv6
        port ||= 1521
        database = "/#{database}" unless database.match(/^\//)
        "//#{host}:#{port}#{database}"
      # if no host is specified then assume that
      # database parameter is TNS alias or TNS connection string
      else
        database
      end

      conn = OCI8.new username, password, connection_string, privilege
      conn.autocommit = true
      conn.non_blocking = true if async
      conn.prefetch_rows = prefetch_rows
      conn.exec "alter session set cursor_sharing = #{cursor_sharing}" rescue nil
      conn.exec "alter session set time_zone = '#{time_zone}'" unless time_zone.blank?

      # Initialize NLS parameters
      Record::DEFAULT_NLS_PARAMETERS.each do |key, default_value|
        value = config[key] || ENV[key.to_s.upcase] || default_value
        if value
          conn.exec "alter session set #{key} = '#{value}'"
        end
      end
      conn
    end
  end
end
