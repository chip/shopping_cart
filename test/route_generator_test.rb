require File.dirname(__FILE__) + '/test_helper.rb'
require 'rails_generator' 
require 'rails_generator/scripts/generate' 
require 'rails_generator/scripts/destroy' 

class RouteGeneratorTest < Test::Unit::TestCase 
  def setup 
    FileUtils.mkdir_p(File.join(fake_rails_root, "config"))  
  end  
  
  def teardown 
    FileUtils.rm_r(fake_rails_root)  
  end  
  
  def test_generates_route 
    content = <<-END
      ActionController::Routing::Routes.draw do |map|
      end
    END
    File.open(routes_path, 'wb') {|f| f.write(content) } 
    
    Rails::Generator::Scripts::Generate.new.run(["shopping_cart"], :destination => fake_rails_root)  
    assert_match /map\.products/, File.read(routes_path)  
    assert_match /map\.carts/, File.read(routes_path)  
    assert_match /map\.orders/, File.read(routes_path)  
  end  

  def test_destroys_route 
    content = <<-END
      ActionController::Routing::Routes.draw do |map| 
        map.products
        map.carts
        map.orders
    END
    File.open(routes_path, 'wb') {|f| f.write(content) }
    
    Rails::Generator::Scripts::Destroy.new.run(["shopping_cart"], :destination => fake_rails_root)      
    assert_no_match /map\.products/, File.read(routes_path)  
    assert_no_match /map\.carts/, File.read(routes_path)  
    assert_no_match /map\.orders/, File.read(routes_path)
  end  
  
  
private 

  def fake_rails_root
    File.join(File.dirname(__FILE__), "rails_root")
  end
  
  def routes_path
    File.join(fake_rails_root, "config", "routes.rb")
  end
  
end 