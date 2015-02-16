class RecordGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def create_congure_file
    copy_file "record.yml","config/record.yml"
  end
end
