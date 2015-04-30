require 'rubygems'

class CommandsDescription

  def self.custom_task_slave
    description = <<-LONGDESC
         Executes previously defined custom maintenance tasks.\n
         Its only used for administrative purposes.\n
          [ENV] could be development, production or any environment defined in config/commercehub.yml file.\n

          Example:\n
           > ruby main.rb custom_task_slave development #Will execute any pre-defined maintenance task for development environment.\n
           > ruby main.rb custom_task_slave production  #Will execute any pre-defined maintenance task for production environment.\n

     LONGDESC

     return description

  end

  def self.licenses_expiring
    description = <<-LONGDESC
         Will check licenses expiration before 90, 45 and 15 days,\n
         then send an email notifing the main contact if any for the company
         whos licenses will expire.

          [ENV] could be development or production .\n

          Example:\n
           > ruby main.rb licenses_expiring development #Will execute licenses_expiring for development environment.\n
           > ruby main.rb licenses_expiring production  #Will execute licenses_expiring for production environment.\n

     LONGDESC

     return description

  end

  def self.notify_holidays
    description = <<-LONGDESC
         Will check which holiday is and notify all contacts,\n
         that allowed notifications and then send an email.

          [ENV] could be development or production .\n

          Example:\n
           > ruby main.rb notify_holidays development #Will execute notify_holidays for development environment.\n
           > ruby main.rb notify_holidays production  #Will execute notify_holidays for production environment.\n

     LONGDESC

     return description

  end

end