require 'yaml'
module Record
  class Configure
    def initialize(config_name = nil)
      @config_name = config_name || :default
      @config = YAML.load(File.open(Rails.root.join('config', 'record.yml')))[@config_name] || {}
    end
    def settings
      @config
    end
    def reset(config_name)
      @config_name = config_name.to_sym
      @config = YAML.load(File.open(Rails.root.join('config', 'record.yml')))[@config_name] || {}
    end
    def description
      "(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=#{@config[:host]})(PORT=#{@config[:port]})))(CONNECT_DATA=(SERVICE_NAME=#{@config[:database]})))"
    end
  end
end
