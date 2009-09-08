require File.dirname(__FILE__) + '/test_helper.rb'
# require 'test_helper'

class OrderTransactionTest < ActiveSupport::TestCase
  load_schema
  
  def test_order_transaction
    assert_kind_of OrderTransaction, OrderTransaction.new 
  end
  
end
