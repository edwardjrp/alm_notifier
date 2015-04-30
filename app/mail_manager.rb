require 'rubygems'
require 'active_record'
require 'fileutils'
require 'digest'
#require 'csv'
require 'securerandom'
require 'chronic'

#require File.expand_path('../../config/alm_notifier_config.rb', __FILE__)
require File.expand_path('../../config/alm_notifier_logger.rb', __FILE__)
require File.expand_path('../../db/models/all_models.rb', __FILE__)
require File.expand_path('../../app/mailers/notifier.rb', __FILE__) #If put before all_models, there is e conflict with env variable since its declared out of class scope

class MailManager

  def initialize(env = 'development')
    @env = env
    @logs = AlmNotifierLogger.new(@env)
  end

  def licenses_expiring
    #Send notification to contacts about soon to expire licenses
    licenses_to_expire(90)
    licenses_to_expire(45)
    licenses_to_expire(15)
    licenses_to_expire(2)
  end

  def notify_holidays
    begin
      contacts = AlmCustomersContacts.can_notify
      contacts.each { |c|

        delivery_email = c.workemail.to_s.squish.empty? ? c.personalemail.to_s.squish : c.workemail.to_s.squish
        if delivery_email.empty?
          false
        else
          #deliver emails
          holidays_ids = c.notify_holidays.to_s.split(",")
          holidays_ids.reject &:blank? #Remove empty or nil values

          if holidays_ids.count > 0
            holidays_ids.each { |h|
              holiday = AlmCustomersContactsHolidays.find(h)
              #Mothers and fathers day, this date is calculated different
              special_days_id = [2,3]
              if special_days_id.include?(holiday.id)
                day_month = holiday.day_month.split(",")
                day_position = holiday.day_position
                if day_month.count == 2 and day_position > 0
                  case day_position
                    when 1 then
                      day_position = "1st"
                    when 2 then
                      day_position = "2nd"
                    when 3 then
                      day_position = "3rd"
                    when 4 then
                      day_position = "4th"
                    when 5 then
                      day_position = "5th"
                    when 6 then
                      day_position = "last"
                    else
                      day_position = nil
                  end

                  month_name = Date::MONTHNAMES[day_month[1].to_i]
                  #days starts on sunday with index 0
                  day_name = Date::DAYNAMES[ ( day_month[0].to_i - 1) ]

                  if day_position == "last"
                    end_of_month = Date.new Date.today.year, Date.today.month, -1
                    mothers_fathers_date = Chronic.parse("#{day_position} #{day_name}", now: end_of_month) #This takes the form of last wednesday based on end of month date
                  else
                    mothers_fathers_date = Chronic.parse("#{day_position} #{day_name} in #{month_name}", now: Date.today) #This takes the form of 4th wednesday in april based on todays date
                  end

                  if mothers_fathers_date
                    mothers_fathers_date = Date.strptime(mothers_fathers_date.to_s,"%Y-%m-%d")
                    if mothers_fathers_date == Date.today
                      Notifier.notify_holiday(delivery_email, holiday, c).deliver_now
                    end

                  end

                end

              else
                birth_budget_days = [6,7]
                if birth_budget_days.include?(holiday.id)
                  #Birthday holiday
                  if holiday.id == 6
                    if c.contact_dob
                      contact_dob =  c.contact_dob.to_date rescue nil
                      if contact_dob
                        #Holiday day_month db field has the format day,month and we are comparing it this way
                        day_month = "#{Date.today.day},#{Date.today.mon}"
                        birth_day_month = "#{contact_dob.day},#{contact_dob.month}"
                        if day_month == birth_day_month
                          Notifier.notify_holiday(delivery_email, holiday, c).deliver_now
                        end

                      end

                    end

                  else
                    #Budget day
                    if holiday.id == 7

                      active_licenses = VAlmLicenses.active_licenses
                      companies = []
                      active_licenses.each { |license| companies << license.company }
                      companies = companies.uniq
                      companies.each { |c|

                        if c.budgetdate == Date.today
                          licenses = c.licenses.active_licenses
                          #Checking if maincontact is present
                          if c.contacts.main_contact
                            delivery_email = c.contacts.main_contact.workemail.to_s.squish.empty? ? c.contacts.main_contact.personalemail.to_s.squish : c.contacts.main_contact.workemail.to_s.squish
                            if delivery_email.empty?
                              false
                            else
                              Notifier.notify_budget(delivery_email, licenses).deliver_now
                            end

                          else
                            #Checking any available contact is present
                            contact =  c.contacts.first
                            if contact
                              delivery_email = contact.workemail.to_s.squish.empty? ? contact.personalemail.to_s.squish : contact.workemail.to_s.squish
                              if delivery_email.empty?
                                false
                              else
                                Notifier.notify_budget(delivery_email, licenses).deliver_now
                              end
                            end

                          end

                        end

                      }

                    end

                  end

                else
                  #Holiday day_month db field has the format day,month and we are comparing it this way
                  day_month = "#{Date.today.day},#{Date.today.mon}"
                  if day_month == holiday.day_month.to_s.squish
                    Notifier.notify_holiday(delivery_email, holiday).deliver_now
                  end

                end

              end

            }

          end

        end

      }

    rescue Exception => e
      @logs.log_fatal_message(e.message)
    end

  end

  private
  def licenses_to_expire(days = 90)
    begin

      expiring_licenses = VAlmLicenses.expiring_in_days(days)
      companies = []
      expiring_licenses.each { |license|
        companies << license.company
      }

      #Remove duplicate companies from the array
      companies = companies.uniq
      companies.each { |c|
        licenses = c.licenses.expiring_in_days(days)

        #Checking if maincontact is present
        if c.contacts.main_contact
          delivery_email = c.contacts.main_contact.workemail.to_s.squish.empty? ? c.contacts.main_contact.personalemail.to_s.squish : c.contacts.main_contact.workemail.to_s.squish
          if delivery_email.empty?
            false
          else
            Notifier.expiring_licences(delivery_email, licenses, days).deliver_now
          end

        else
          #Checking any available contact is present
          contact =  c.contacts.first
          if contact
            delivery_email = contact.workemail.to_s.squish.empty? ? contact.personalemail.to_s.squish : contact.workemail.to_s.squish
            if delivery_email.empty?
              false
            else
              Notifier.expiring_licences(delivery_email, licenses, days).deliver_now
            end
          end

        end

      }

    rescue Exception => e
      @logs.log_fatal_message(e.message)
    end

  end

end