require 'fileutils'
 
module ShoppingCart #:nodoc
  module SetupTasks #:nodoc
 
    def self.do_setup 
      begin
        puts "STEP 1 -- Generate ShoppingCart migration file"
        generate_migration
        write_migration_content
        puts "STEP 2 -- ShoppingCart plugin view files and stylesheet"
        copy_view_files
        copy_stylesheet
        puts "Followup Steps"
        puts "STEP 3 -- run the task 'rake db:migrate'\n"
        puts "STEP 4 -- edit the file config/routes.rb"
        puts <<-END_ROUTES
          map.root :controller => 'products', :action => 'index'
          map.resources :products
          map.current_cart 'cart', :controller => 'carts', :action => 'show', :id => 'current'
          map.resources :carts
          map.resources :orders
          
        END_ROUTES
        puts "STEP 5 -- Shopping Cart Gateway setup"
        puts <<-END_GATEWAY
        (config/development.rb):
        ActiveMerchant::Billing::Base.mode = :test
        ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
          :login      => "your paypal sandbox login",
          :password   => "your paypal sandbox password",
          :signature  => "your paypal sandbox signature"
        )
        
        (config/test.rb):
        config.after_initialize do
          ActiveMerchant::Billing::Base.mode = :test
          ::GATEWAY = ActiveMerchant::Billing::BogusGateway.new
        end
        
        (config/production.rb):
        ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
          :login      => "your paypal login",
          :password   => "your paypal password",
          :signature  => "your paypal signature"
        )
        
        END_GATEWAY
        puts "STEP 6 -- Install Ruby Gems:\nsudo gem install activemerchant haml highline\n\n"
        puts "STEP 7 -- Edit environment.rb:\nconfig.gem 'haml'\nconfig.gem \"activemerchant\", :lib => \"active_merchant\", :version => \"1.4.1\"\nRestart web server\n\n"
        puts "STEP 8 (optional) -- run the task 'rake shopping_cart:products'\n"
      rescue StandardError => e
        p e
      end
    end
 
    private
 
    def self.generate_migration
      migration_filename = get_migration_filename
      # puts "generate_migration: #{migration_filename}"
      if File.exists?(migration_filename)
        "#{migration_filename} already exists.  Skipping migration generation...\n"
      else
        puts "==============================================================================="
        puts "ruby script/generate migration create_shopping_cart_tables"
        puts %x{ruby script/generate migration create_shopping_cart_tables}
        puts "================================DONE==========================================="
      end
    end
  
    def self.migration_source_file
      File.join(File.dirname(__FILE__), "../assets", "migration", "create_shopping_cart_tables.rb")
    end
 
    def self.write_migration_content
      migration_filename = get_migration_filename
      if File.exists?(migration_filename)
        puts "#{migration_filename} already exists, so skipping migration creation\n"
      else
        File.open(migration_file, "wb"){|f| f.write(File.read(migration_source_file))}
      end
    end
 
    def self.get_migration_filename
      copy_to_path = File.join(RAILS_ROOT, "db", "migrate")
      migration_filename =
        Dir.entries(copy_to_path).collect do |file|
          number, *name = file.split("_")
          file if name.join("_") == "create_shopping_cart_tables.rb"
        end.compact.first
      File.join(copy_to_path, migration_filename)
    end
    
    def self.copy_view_files
      %w(carts orders products).each do |dir|
        view_directory = File.join(RAILS_ROOT, "app/views/#{dir}")
        if File.exist?(view_directory)
          puts "#{view_directory} already exists.  Skipping directory creation...\n"
        else
          puts "Creating directory: #{view_directory}"
          mkdir_p(view_directory)
        end
        view_files = File.join(File.dirname(__FILE__), "../assets", "views", dir)
        Dir.entries(view_files).collect do |file|
          source_file = File.join(File.dirname(__FILE__), "../assets", "views", dir, file)
          destination_file = File.join(RAILS_ROOT, "app/views/#{dir}", File.basename(file))
          next if source_file =~ /\.$/
          if File.exists?(destination_file)
            puts "#{destination_file} already exists.  Skipping file copy...\n"
          else
            puts "Copying #{source_file} to #{destination_file}\n"
            FileUtils.cp(source_file, destination_file)
          end
        end
      end
      puts "================================DONE===========================================\n"
    end
    
    def self.copy_stylesheet
      file = "shopping_cart.sass"
      source_file = File.join(File.dirname(__FILE__), "../assets", "stylesheets", file)
      destination_file = File.join(RAILS_ROOT, "public/stylesheets", File.basename(file))
      if File.exists?(destination_file)
        puts "#{destination_file} already exists.  Skipping file copy...\n"
      else
        puts "Copying #{source_file} to #{destination_file}\n"
        FileUtils.cp(source_file, destination_file)
      end
      puts "Include shopping_cart.css from your layout\n\n"
      puts "================================DONE===========================================\n"      
    end
  end
end