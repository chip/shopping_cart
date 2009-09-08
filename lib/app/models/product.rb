class Product < ActiveRecord::Base 
  belongs_to :category
  has_many :line_item
end