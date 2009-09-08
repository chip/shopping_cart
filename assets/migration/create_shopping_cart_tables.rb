class CreateShoppingCartTables < ActiveRecord::Migration
  def self.up
    create_table "products", :force => true do |t|
      t.string   "name"
      t.text     "description"
      t.integer  "price"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "image"
    end
  
    create_table "carts", :force => true do |t|
      t.datetime "purchased_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "line_items", :force => true do |t|
      t.integer  "unit_price", :limit => 10, :precision => 10, :scale => 0
      t.integer  "product_id"
      t.integer  "cart_id"
      t.integer  "quantity"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "orders", :force => true do |t|
      t.integer  "cart_id"
      t.string   "ip_address"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "card_type"
      t.date     "card_expires_on"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "order_transactions", :force => true do |t|
      t.integer  "order_id"
      t.string   "action"
      t.integer  "amount"
      t.boolean  "success"
      t.string   "authorization"
      t.string   "message"
      t.text     "params"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "billing_addresses", :force => true do |t|
      t.string   "address1"
      t.string   "city"
      t.string   "billing_state"
      t.string   "country"
      t.string   "zip"
      t.integer  "order_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
  
  def self.down
    drop_table :products
    drop_table :carts
    drop_table :line_items
    drop_table :orders
    drop_table :order_transactions
  end
end
