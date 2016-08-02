require 'nokogiri'
require 'open-uri'

class URLCategoryReader

  def self.links(url)
    new.links(url)
  end

  def links(url)
    page    = read(url)

    parts   = get_all_paginate_parts(page, url)
    anchors = get_all_anchors(parts)
    hrefs   = get_hrefs(anchors)
    links   = get_links(hrefs, url)
    links
  end

  private

  def read(url)
    Nokogiri::HTML(open(url))
  end

  def get_all_paginate_parts(page, url)
    hrefs = find_pagination(page)
    links_to_parts = get_links(hrefs, url)
    links_to_parts.pop
    links_to_parts.map do |links|
      read(links)
    end
  end

  def find_pagination(page)
    page.css('div.pagination ul li a').map { |anchor| anchor['href'] }
  end

  def get_all_anchors(parts)
    parts.map { |part|
      get_anchors(part)
    }.flatten
  end

  def get_anchors(part)
    part.css('ul.families-list').css('li>a')
  end

  def get_hrefs(anchors)
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
