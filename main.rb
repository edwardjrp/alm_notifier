require 'rubygems'
require 'active_record'
require 'thor'

require File.expand_path('../config/commands_description.rb', __FILE__)
require File.expand_path('../app/mail_manager.rb', __FILE__)

require File.expand_path('../db/models/all_models.rb', __FILE__)


class AlmNotifier < Thor

  #Nap time for each daemonized method in seconds, 180sec = 3 minutes
  NAP_TIME = 3.minutes
  NAP_TIME_DAILY = 24.hours

  desc "licenses_expiring [ENV]","Will check licenses expiration before 90, 45 and 15 days and send an email, More info type ruby ./main.rb help licenses_expiring"
  long_desc CommandsDescription.licenses_expiring
  def licenses_expiring(env = 'development', mode = 'cli')

    case mode
      when 'daemon'
        loop do
          mail_manager = MailManager.new(env)
          mail_manager.licenses_expiring
          sleep(NAP_TIME_DAILY)
        end
      else
        mail_manager = MailManager.new(env)
        mail_manager.licenses_expiring
    end
  end

  desc "notify_holidays [ENV]","Will check which holiday is and notify all contacts that allowed notifications and send an email, More info type ruby ./main.rb help notify_holidays"
  long_desc CommandsDescription.notify_holidays
  def notify_holidays(env = 'development', mode = 'cli')

    case mode
      when 'daemon'
        loop do
          mail_manager = MailManager.new(env)
          mail_manager.notify_holidays
          sleep(NAP_TIME_DAILY)
        end
      else
        mail_manager = MailManager.new(env)
        mail_manager.notify_holidays
    end
  end


  desc "custom_task_slave [ENV]","Executes previously defined custom maintenance tasks. Its only used for administrative purposes, More info type ruby ./main.rb help custom_task_slave"
  long_desc CommandsDescription.custom_task_slave
  def custom_task_slave(env = 'development', mode = 'cli')

    case mode
      when 'daemon'
        loop do
          mail_manager = MailManager.new(env)
          mail_manager.welcome
          sleep(NAP_TIME)
        end
      else
        mail_manager = MailManager.new(env)
        mail_manager.welcome
        puts 'DONE'
        puts ENV['ALM_ENV']

    end

  end


end

AlmNotifier.start(ARGV)
