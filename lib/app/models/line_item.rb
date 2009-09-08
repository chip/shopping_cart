class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product
  
  validates_presence_of :quantity, :message => "can't be blank"
  validates_numericality_of :quantity, :message => "is not a number", :greater_than => 0, :only_integer => true
    
  def full_price
    unit_price * quantity
  end
end
