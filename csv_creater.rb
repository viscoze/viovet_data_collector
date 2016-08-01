require 'csv'

class CSVCreater
  def self.create_csv_file(filename, category_data)
    new.create_csv_file(filename, category_data)
  end  

  def create_csv_file(filename, category_data)
    products_data = get_products_from_category(category_data)
    write_csv(filename, products_data)
  end

  private

  def write_csv(filename, products)
    CSV.open(filename, "wb") do |csv|
      csv << products.first.keys
      products.each do |product|
        csv << product.values
      end
    end
  end

  def get_products_from_category(category_data)
    category_data.map do |products|
      products[:products]
    end.flatten
  end
end
