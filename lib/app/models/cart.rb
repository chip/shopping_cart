class Cart < ActiveRecord::Base
  # has_many :products, :through => :line_items
  has_one :order
  has_many :line_items, :dependent => :destroy

  validates_associated :line_items
  
  after_update :save_line_items
  
  attr_accessible :existing_line_item_attributes
  
  def total_price
    # convert to array so it doesn't try to do sum on database directly
    line_items.to_a.sum(&:full_price)
  end
  
  def new_line_item_attributes=(line_item_attributes)
    # logger.info "inside new_line_item_attributes #{line_item_attributes.to_yaml}"
    line_item_attributes.each do |attributes| 
      line_item.build(attributes) 
    end   
  end
  
  def existing_line_item_attributes=(line_item_attributes)
    # logger.info "line_item_attributes=#{line_item_attributes}\nline_item_attributes.class=#{line_item_attributes.class}\n"
    # logger.info "line_items=#{line_items}\nline_items.class=#{line_items.class}\n"
    
    line_items.reject(&:new_record?).each do |line_item|
      # logger.info "line_item.id=#{line_item.id}\nline_item.class=#{line_item.class}\n"
      if line_item_attributes["#{line_item.id}"]["quantity"].to_i > 0
        attributes = line_item_attributes["#{line_item.id}"]
      end
      # logger.info "attributes=#{attributes}"
      if attributes 
        line_item.attributes = attributes 
      else 
        # logger.info "supposed to delete here, but commented out"
        line_items.delete(line_item) 
      end 
    end
  end 
  
  def save_line_items
    line_items.each do |li|
      li.save(false)
    end
  end
end
