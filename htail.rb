require 'httparty'
require 'diffy'
require 'nokogiri'

site = ARGV[0]
recipient = ARGV[1]
now = Time.now
counter = 1

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
	if Time.now < now + counter
		next
	elsif site_now.to_s != site_origin.to_s
		diff = Diffy::Diff.new(site_origin, site_now).to_s(:html)
		puts get_links(site)
		site_origin = site_now
	else
		puts "no change..."
	end
end