require 'httparty'
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
	links = []
	if site_now.to_s != site_origin.to_s
		now = (Time.now).to_s
		message = "CHANGE FOUND at " + now
		puts message
		links_origin = get_links(site_origin)
		links_now = get_links(site_now)
		for link in links_now
			if !(links_origin.include? link)
				puts ("NEW LINK: " + link.to_s) 
				links << link
			end
		end
		links = links.to_s
		(`echo "#{links}" | mail -s "#{site} update at #{now}" #{recipient}`) if links != '[]'
		site_origin = site_now
	end
end