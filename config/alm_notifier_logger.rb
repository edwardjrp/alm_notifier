require "rubygems"
require "active_record"
require "yaml"
require "fileutils"
require "logger"

class AlmNotifierLogger

  def initialize(env = 'development')
    if env == 'development'
      file = File.expand_path("../logs.txt", __FILE__)
    else
      file = File.expand_path("../logs.txt", __FILE__)
    end
    @log = Logger.new(file,"weekly")
    @env = env
  end

  def get_logger
    @log
  end

  def log_debug_message(message)
    if @env == 'development'
      @log.level = Logger::DEBUG
      @log.debug message
    end
  end

  def log_fatal_message(message)
    @log.level = Logger::FATAL
    @log.fatal message
  end

  def log_info_message(message)
    if @env == 'development'
      @log.info message
    end
  end


  def self.log_error_message(message)
    @log.level = Logger::ERROR
    @log.error message
  end

end