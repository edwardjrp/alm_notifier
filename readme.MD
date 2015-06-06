# Console daemonizable email notificacion app

## Overview
This is a cli app who also can be daemonized uses the pretty cool thor gem and actionmailer gem to send notifications.

### Syntax
After installing bundler and running bundle install just run the following command and it will tell you a description of the available commands which based on thor is basicalle the methods exposed on the main class with a few tweaks.


	ruby main.rb
    EdwardData:alm_notifier EdwardData$ ruby main.rb
	Commands:
	  main.rb custom_task_slave [ENV]  # Executes previously defined custom maintenance tasks. Its only used for administrative purposes, More info type ruby ./main.rb help custom_task_slave
	  main.rb help [COMMAND]           # Describe available commands or one specific command
	  main.rb licenses_expiring [ENV]  # Will check licenses expiration before 90, 45 and 15 days and send an email, More info type ruby ./main.rb help licenses_expiring
	  main.rb notify_holidays [ENV]    # Will check which holiday is and notify all contacts that allowed notifications and send an email, More info type ruby ./main.rb help notify_holidays

Running the `notify_holidays` task:

	ruby main.rb notify_holidays production daemon

This command will automatically run and daemonize the task. If the daemon parameter is not
included it will be run as cli mode, meaning it will just run it once and exit.
		
	
		

#### Please take a look to the notifier class in `app/mailers/notifier.rb`, there are a few setup parameters for actionmailer to be able to integrate correctly the html layout and templates.

#### The `hell/` directory
This is where all the daemons scripts are to start and stop each daemonized method.
To stop or start all daemons just run any of the following shell scripts.

* `crowley_start.sh`
* `crowley_stop.sh`

The `hell/pids` folder is where all the process id's and logs for each daemon will be in case something happends.