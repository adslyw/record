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
  class Base
    attr_accessor :connection, :result
    def initialize
      @result = nil
      @config = Configure.new
      @connection = Connection.new(@config.settings)
    end
  end
end
