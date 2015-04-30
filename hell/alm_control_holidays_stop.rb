require 'rubygems'
require 'daemons'

options = {
  :app_name   => "alm_holidays",
  #:ARGV       => ['start', '-f', '--', 'param_for_myscript'],
  :ARGV       => ['stop'],
  #:dir_mode   => :script,
  :dir        => 'hell/pids',
  :multiple   => false,
  #:ontop      => true,
  #:mode       => :exec,
  :backtrace  => true,
  #:monitor    => true,
  :log_output => true
}

script_path = File.dirname(File.absolute_path(__FILE__)) << '/../'
script_path = File.join(script_path, 'main.rb')
Daemons.run(script_path, options )