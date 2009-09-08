require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/shopping_cart.rb'

class ShoppingCartTest < ActiveSupport::TestCase
  load_schema
  
  class Product < ActiveRecord::Base
  end
  
  class Cart < ActiveRecord::Base
  end
  
  class LineItem < ActiveRecord::Base
  end
  
  class Order < ActiveRecord::Base
  end
  
  class OrderTransaction < ActiveRecord::Base
  end
  
  def test_schema_has_loaded_correctly
    assert_equal [], Product.all
    assert_equal [], Cart.all
    assert_equal [], LineItem.all
    assert_equal [], Order.all
    assert_equal [], OrderTransaction.all
  end
end
