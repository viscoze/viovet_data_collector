require 'uri'

require './url_category_reader.rb'
require './url_data_reader.rb'
require './csv_creater.rb'

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

  def get_info_from_command_line
    url = ARGV[0]
    filename = ARGV[1]

    [url, filename]
  end
end

main = Main.new
main.start
