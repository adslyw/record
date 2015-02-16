class RecordGenerator < Rails::Generators::Base
  def create_configure_file
    create_file "config/record.yml",""
  end
end
