require 'rails_generator'
require 'rails_generator/commands'

module ShoppingCart #:nodoc:
  module Generator #:nodoc:
    module Commands #:nodoc:
      module Create
        def routes
          logger.route "Creating shopping_cart routes"
          look_for = 'ActionController::Routing::Routes.draw do |map|'
          unless options[:pretend]
            gsub_file('config/routes.rb', /(#{Regexp.escape(look_for)})/mi) do |match| 
              "#{match}\n  map.resources :products\n  map.resources :carts\n  map.resources :orders\n"
            end
          end
        end
      end  
      
      module Destroy
        def routes
          logger.route "Destroying shopping_cart routes"
          gsub_file 'config/routes.rb', /\n.+?map\.resources :products/mi, ''
          gsub_file 'config/routes.rb', /\n.+?map\.resources :carts/mi, ''
          gsub_file 'config/routes.rb', /\n.+?map\.resources :orders/mi, ''
        end
      end  
      
      module List
        def routes
        end
      end
      
      module Update
        def routes
        end
      end
    end
  end 
end
Rails::Generator::Commands::Create.send   :include, ShoppingCart::Generator::Commands::Create
Rails::Generator::Commands::Destroy.send  :include, ShoppingCart::Generator::Commands::Destroy
Rails::Generator::Commands::List.send     :include, ShoppingCart::Generator::Commands::List
Rails::Generator::Commands::Update.send   :include, ShoppingCart::Generator::Commands::Update 