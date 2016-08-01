require 'nokogiri'

class URLDataReader

  def self.get_category(links)
    new.get_category(links)
  end

  def get_category(links)
    category = process_category(links)
  end

  private

  def process_category(links)
    threads  = []
    category = []

    links.map do |link|
      threads << Thread.new do
        category << get_multiproduct(link)
      end
    end

    threads.map(&:join)
    category
  end

  def get_multiproduct(link)
    page     = Nokogiri::HTML(open(link))
    name     = find_name(page)
    products = process_products(page, name)

    { product_family_name: name, products: products }
  rescue
    { product_family_name: "http error", products: [] }
  end

  def process_products(page, name)
    products_html = page.css('li.product')
    products_html.map do |product_html|
      title    = find_product_title(product_html)
      price    = find_product_price(product_html)
      image    = find_product_image(product_html)
      dispatch = find_product_dispatch(product_html)
      code     = find_product_code(product_html)

      title = "#{name} - #{title}"

      { title: title, price: price, image: image, dispatch: dispatch, code: code }
    end
  end

  def find_name(page)
    page.css('#product_family_heading').text
  end

  def find_product_title(product_html)
    product_html.css('div.title').text.gsub("\t", "").gsub("\n", "")
  end

  def find_product_price(product_html)
    product_html.css('span[itemprop="price"]').text
  end

  def find_product_image(product_html)
    image_url = product_html.css('ul.buttonthings li')
                            .css('a.photo-view')
                            .first['href']

    "http:#{image_url}"
  rescue
    nil
  end

  def find_product_dispatch(product_html)
    product_html.css('strong.stock.in-stock').text.gsub("\t", "").gsub("\n", "")
  end

  def find_product_code(product_html)
    product_html.css('strong[itemprop="sku"]').text
  end
end
