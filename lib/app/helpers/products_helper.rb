module ProductsHelper
  def product_image(label)
    image_tag("/images/products/#{label}.png")
  end
end