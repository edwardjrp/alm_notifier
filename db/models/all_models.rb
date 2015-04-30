require 'active_record'
#New active record versions generate attribute accesors which causes issues with fields that matches the active record convention for a model
require "safe_attributes/base"
require 'securerandom'
require File.expand_path('../../../config/alm_notifier_config.rb', __FILE__)

env = 'development'
if ENV.has_key?('ALM_ENV')
  env = ENV['ALM_ENV']
end

params = AlmNotifierConfig.get_database_config()
#Avoid table name pluralization to easyly integrate with existing schema definition on alm database
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.establish_connection(params[env])

class VAlmLicenses < ActiveRecord::Base
  belongs_to :company, class_name: "AlmCustomers", foreign_key: "id_customer"

  scope :active_licenses, -> {where(id_license_status: 2)}

  def self.expiring_in_days(days = 90)
    future_date = Date.today.advance(days: days)
    where(expiration_date: future_date)
  end

end

class AlmLicensing < ActiveRecord::Base
end

class AlmProducts < ActiveRecord::Base
end

class AlmCustomers < ActiveRecord::Base
  has_many :licenses, class_name: "VAlmLicenses" , foreign_key: "id_customer"
  has_many :contacts, class_name: "AlmCustomersContacts", foreign_key: "customer_id"

end

class AlmCustomersContacts < ActiveRecord::Base

  scope :can_notify, -> { where(allow_notifications: 1) }

  def self.main_contact
    where(maincontact: 1).first #If put into a scope the first method doesnt work
  end

end

class AlmCustomersContactsHolidays < ActiveRecord::Base
end

class Options < ActiveRecord::Base

  scope :console_parameters, -> { where("variable like 'console_%'") }
  scope :website_parameters, -> { where("variable like 'website_%'") }

  def self.console_params_hash
    options = Options.console_parameters
    params = {}
    options.each { |p|
      params[p.variable.strip] = p.value.strip
    }
    params
  end

  def self.website_params_hash
    options = Options.website_parameters
    params = {}
    options.each { |p|
      params[p.variable.strip] = p.value.strip
    }
    params
  end

end


# class OrderDetails < ActiveRecord::Base
#   #belongs_to :orders, :class_name => 'Orders', :foreign_key => 'hub_order_id'
#
#   before_create :set_guid
#
#   scope :details_by_merchant_order_id, ->(merchant_order_id = '') {where(merchant_order_id: merchant_order_id)}
#   scope :returned_orders, -> { where(status_id: 7) }
#   scope :details_by_order_id, ->(order_id = nil) {where(order_id: order_id)}
#
#   private
#   def set_guid
#     self.guid = SecureRandom.uuid
#   end
#
#   def self.order_item_exist(hub_line_id = nil)
#     self.where(hub_line_id: hub_line_id).first
#   end
#
# end

# class Inventory < ActiveRecord::Base
#   before_create :set_guid
#
#   scope :available_products, -> {where('cost > 0')}
#   scope :retailer_products, ->(retailer_id = 0) {where(retailer_id: retailer_id)}
#
#   private
#   def set_guid
#     self.guid = SecureRandom.uuid
#   end
#
# end


# class VwShipInvReady < ActiveRecord::Base
#   self.table_name = "vw_Ship_Inv_Ready"
#   scope :retailer_orders, ->(retailer_id = 0) {where(retailer_id: retailer_id)}
#   scope :header_by_merchant_order_id, ->(merchant_order_id = nil) {where(merchant_order_id: merchant_order_id)}
#
# end


# class BelkInv < ActiveRecord::Base
#   self.table_name = "belk_inv"
# end
