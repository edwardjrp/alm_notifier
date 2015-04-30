require 'yaml'
require 'fileutils'

class AlmNotifierConfig

  # def self.get_commercehub_config(env = 'development')
  #   commercehub_config_file = File.expand_path('../commercehub.yml', __FILE__)
  #
  #   #loading yaml config
  #   config_content = YAML::load(File.open(commercehub_config_file))
  #
  #   return config_content[env]
  # end

  def self.get_database_config()
    database_config_file = File.expand_path('../../db/config.yml', __FILE__)

    #loading yaml config
    config_content = YAML::load(File.open(database_config_file))

    return config_content
  end

end