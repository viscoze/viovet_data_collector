require 'uri'

require './URLCategoryReader.rb'
require './URLDataReader.rb'
require './CSVCreater.rb'


TEST_URL = "https://www.viovet.co.uk/Pet_Foods_Diets-Dogs-Hills_Pet_Nutrition-Hills_Prescription_Diets/c233_234_2678_93/category.html"

class Main
  def start
    user_input = get_info_from_user
    run(*user_input)
  end

  def run(url, filename)
    links    = URLCategoryReader.links(url)
    category = URLDataReader.get_category(links)
    
    CSVCreater.create_csv_file(filename, category)
  end

  def get_info_from_user
    puts "Enter URL: "
    url = gets.chomp
    puts "Enter filename: "
    filename = gets.chomp

    [url, filename]
  end
end

main = Main.new
main.start
