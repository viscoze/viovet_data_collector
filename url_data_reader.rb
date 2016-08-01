require 'nokogiri'
require './product_data_reader.rb'

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
  rescue => e
    puts e
    { product_family_name: "http error", products: [] }
  end

  def process_products(page, name)
    product_data_reader = ProductDataReader.new
    product_data_reader.set_product_family_name(name)

    page.css('li.product').map do |product_html|
      product_data_reader.set_product_html(product_html)
      product_data_reader.get_product_data
    end
  end

  def find_name(page)
    page.css('#product_family_heading').text
  end
end
