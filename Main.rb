require 'uri'

require './URLCategoryReader.rb'
require './URLDataReader.rb'
require './CSVCreater.rb'

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
