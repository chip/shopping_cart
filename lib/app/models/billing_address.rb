class BillingAddress < ActiveRecord::Base
  belongs_to :order
  
  validates_presence_of :address1, :city, :billing_state, :zip, :country, :on => :create, :message => 'cannot be empty'
end