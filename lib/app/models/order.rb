class Order < ActiveRecord::Base
  belongs_to :cart
  has_many :transactions, :class_name => "OrderTransaction"
  has_one :billing_address, :class_name => 'BillingAddress'
    
  validate_on_create :validate_card, :validate_billing_address
  
  attr_accessor :card_number, :card_verification
  
  def purchase
    logger.info "credit_card=#{credit_card.to_yaml}\nprice_in_cents=#{price_in_cents}"
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    cart.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
  end
  
  def price_in_cents
    (cart.total_price*100).round
  end

  def total_price
    cart.total_price
  end
  
  private
  
  def purchase_options
    options = {:ip => ip_address}
    if RAILS_ENV['development']
      options.merge!(
        :billing_address  => {
          :address1 => "155 Crystal Beach Drive",
          :city     => "Destin",
          :state    => "FL",
          :country  => "US",
          :zip      => "32541"
      })
    end
    options
  end
  
  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
      credit_card.errors.each do |attr, message|
        logger.info "attr=#{attr}\nmessage=#{message}"
        case attr
          when 'type'
            errors.add :card_type, message
          when 'number'
            errors.add :card_number, message
          when 'verification_value'
            errors.add :card_verification, message
          else
            errors.add attr, message
        end
      end
    end
  end
  
  def validate_billing_address
    unless self.billing_address.valid?
      # self.billing_address.errors.full_messages.each do |message|
      #   errors.add_to_base message
      # end
      self.billing_address.errors.each do |attr, message|
        logger.info "attr=#{attr}\nmessage=#{message}"
        errors.add attr, message
      end
    end  
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end
end
