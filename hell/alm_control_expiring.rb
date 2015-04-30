require 'rubygems'
require 'daemons'

env = 'development'
if ENV.has_key?('ALM_ENV')
  env = ENV['ALM_ENV']
end

options = {
  :app_name   => "alm_expiring_licenses",
  #:ARGV       => ['start', '-f', '--', 'param_for_myscript'],
  :ARGV       => ['start', '--', 'licenses_expiring', env, 'daemon'],
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