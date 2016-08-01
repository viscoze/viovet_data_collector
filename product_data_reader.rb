class ProductDataReader
  def set_product_html(product_html)
    @product_html = product_html
  end

  def set_product_family_name(name)
    @name = name
  end

  def get_product_data
    title    = find_product_title
    price    = find_product_price
    image    = find_product_image
    dispatch = find_product_dispatch
    code     = find_product_code

    title = "#{@name} - #{title}"

    { title: title, price: price, image: image, dispatch: dispatch, code: code }
  end

  private

  def find_product_title
    @product_html.css('div.title').text.gsub("\t", "").gsub("\n", "")
  end

  def find_product_price
    @product_html.css('span[itemprop="price"]').text
  end

  def find_product_image
    image_url = @product_html.css('ul.buttonthings li')
                            .css('a.photo-view')
                            .first['href']

    "http:#{image_url}"
  rescue
    nil
  end

  def find_product_dispatch
    @product_html.css('strong.stock.in-stock').text.gsub("\t", "").gsub("\n", "")
  end

  def find_product_code
    @product_html.css('strong[itemprop="sku"]').text
  end
end
