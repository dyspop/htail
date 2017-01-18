require 'httparty'
require 'diffy'
require 'nokogiri'

site = ARGV[0]
recipient = ARGV[1]
now = Time.now

site_origin = HTTParty.get(site)

def get_links(url)
  Nokogiri::HTML(url).css("a").map do |link|
    if (href = link.attr("href")) && href.match(/^https?:/)
      href
    end
  end.compact
end

loop do
	site_now = HTTParty.get(site)
	if site_now.to_s != site_origin.to_s
		puts "CHANGE FOUND at " + (Time.now).to_s
		links_origin = get_links(site_origin)
		links_now = get_links(site_now)
		for link in links_now
			puts ("NEW LINK: " + link.to_s) if !(links_origin.include? link)
		end
		site_origin = site_now
	else
		puts "no change..."
	end
end