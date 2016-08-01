require 'nokogiri'
require 'open-uri'

class URLCategoryReader
  
  def self.links(url)
    new.links(url)
  end

  def links(url)
    page    = read(url)
    anchors = get_anchors(page)
    hrefs   = get_hrefs(anchors)
    links   = get_links(hrefs, url)
    links
  end

  private

  def read(url)
    Nokogiri::HTML(open(url))
  end

  def get_anchors(page)
    page.css('ul.families-list').css('li>a')
  end

  def get_hrefs(anchors) # return [] of links
    anchors.map do |anchor|
      anchor['href']
    end
  end

  def get_links(hrefs, url)
    uri = URI(url)
    host = "#{uri.scheme}://#{uri.host}"

    hrefs.map do |href|
      "#{host}#{href}"
    end
  end
end
