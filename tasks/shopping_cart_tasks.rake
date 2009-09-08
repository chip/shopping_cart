namespace :shopping_cart do
  desc "Shopping Cart - Populate Products for application"
  task :products => :environment do
    Product.create!({:name => "HOD T",   :description => "Head of Doom Logo T-shirt with long sleeves",  :price => "19.99"})   
    Product.create!({:name => "HOD LS",  :description => "Head of Doom Logo shirt with long sleeves",    :price => "29.99"})   
    Product.create!({:name => "HOD Mug", :description => "Head of Doom Logo Coffee Mug",                 :price => "9.99"})   
  end
  
  desc "Shopping Cart - Setup"
  task :setup => :environment do
    ShoppingCart::SetupTasks.do_setup
  end
end