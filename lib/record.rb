require "record/engine"
require "record/configure"
require "record/connection"
require "record/result"
module Record
  DEFAULT_NLS_PARAMETERS = {
        :nls_calendar            => nil,
        :nls_comp                => nil,
        :nls_currency            => nil,
        :nls_date_format         => 'YYYY-MM-DD HH24:MI:SS',
        :nls_date_language       => nil,
        :nls_dual_currency       => nil,
        :nls_iso_currency        => nil,
        :nls_language            => nil,
        :nls_length_semantics    => 'CHAR',
        :nls_nchar_conv_excp     => nil,
        :nls_numeric_characters  => nil,
        :nls_sort                => nil,
        :nls_territory           => nil,
        :nls_timestamp_format    => 'YYYY-MM-DD HH24:MI:SS:FF6',
        :nls_timestamp_tz_format => nil,
        :nls_time_format         => nil,
        :nls_time_tz_format      => nil
      }
  class Executor
    attr_accessor :connection, :config, :result
    def initialize(config = :default)
      @result = nil
      @config = config
      @connection = Connection.new(Configure.new(@config).settings)
    end
    def query(sql)
      cols, rows = @connection.select(sql)
      @result = Result.new(cols, rows)
    end
    def exec(sql)
      @connection.exec(sql)
    end
    def make_database_link(link_name)
      config = Configure.new(@config)
      user_name = config.settings[:username]
      pass_word = config.settings[:password]
      description = config.description
      sql = "create database link #{link_name} connect to #{user_name} identified by #{pass_word} using '#{description}'"
      exec sql
    end
  end
end
