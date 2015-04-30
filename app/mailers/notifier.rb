require 'rubygems'
require 'active_record'
require 'action_mailer'
require File.expand_path('../../../config/alm_notifier_config.rb', __FILE__)

env = 'development'
if ENV.has_key?('ALM_ENV')
  env = ENV['ALM_ENV']
end

all_params = AlmNotifierConfig.get_database_config()
mail_params = all_params[env]

#ActionMailer::Base.prepend_view_path('./') #Specify the root dir of template path specified later on

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
  address:        mail_params["mail_host"], # default: localhost
  port:           mail_params["mail_port"], # default: 25
  domain:         mail_params["mail_domain"],
  #user_name:      mail_params["mail_username"],
  #password:       mail_params["mail_password"],
  authentication: mail_params["mail_authentication"], # :plain, :login or :cram_md5
  :enable_starttls_auto => true,
  #:ssl => true
}
ActionMailer::Base.view_paths = File.expand_path('../../../app/views/mailers/', __FILE__)

class Notifier < ActionMailer::Base
  #default from: 'license@adexsus.com'
  #default template_path: "app/views"
  layout "layout"

  def welcome(recipient)

    #Spliting username from email since exchange authenticates without the @ part
    params = Options.console_params_hash
    user_name = params["console_license_email"]
    from = user_name
    user_name = user_name.split("@")
    user_name = user_name.first
    delivery_options = {user_name: user_name, password: params["console_license_email_password"]}

    @recipient = recipient
    mail(to: recipient, subject: "Im a test welcome email dude!", content_type: "text/html",
         delivery_method_options: delivery_options,
         from: "Adexsus License Manager <#{from}>"
    )

  end

  def expiring_licences(recipient, licenses, expiring_days = 90)
    #Spliting username from email since exchange authenticates without the @ part
    params = Options.console_params_hash
    user_name = params["console_license_email"]
    from = user_name
    user_name = user_name.split("@")
    user_name = user_name.first
    delivery_options = {user_name: user_name, password: params["console_license_email_password"]}

    @recipient = recipient
    @expiring_days = expiring_days
    @website_hash = Options.website_params_hash
    @licenses = licenses

    mail(to: recipient, subject: "Licenses expiring in #{@expiring_days} days", content_type: "text/html",
         delivery_method_options: delivery_options,
         from: "Adexsus License Manager <#{from}>"
    )

  end

  def notify_holiday(recipient, holiday, contact = nil)
    #Spliting username from email since exchange authenticates without the @ part
    params = Options.console_params_hash
    user_name = params["console_license_email"]
    from = user_name
    user_name = user_name.split("@")
    user_name = user_name.first
    delivery_options = {user_name: user_name, password: params["console_license_email_password"]}

    @recipient = recipient
    @website_hash = Options.website_params_hash
    @holiday = holiday
    @contact = contact

    mail(to: recipient, subject: "#{@holiday.holidays}", content_type: "text/html",
         delivery_method_options: delivery_options,
         from: "Adexsus License Manager <#{from}>"
    )

  end

  def notify_budget(recipient, licenses)
    #Spliting username from email since exchange authenticates without the @ part
    params = Options.console_params_hash
    user_name = params["console_license_email"]
    from = user_name
    user_name = user_name.split("@")
    user_name = user_name.first
    delivery_options = {user_name: user_name, password: params["console_license_email_password"]}

    @recipient = recipient
    @website_hash = Options.website_params_hash
    @licenses = licenses

    mail(to: recipient, subject: "Active licenses for budget purposes", content_type: "text/html",
         delivery_method_options: delivery_options,
         from: "Adexsus License Manager <#{from}>"
    )

  end

end