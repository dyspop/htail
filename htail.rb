require 'httparty'
require 'diffy'

site = ARGV[0]
recipient = ARGV[1]
now = Time.now
counter = 1

site_origin = HTTParty.get(site)

loop do
	site_now = HTTParty.get(site)
	if Time.now < now + counter
		next
	elsif site_now.to_s != site_origin.to_s
		diff = "<style>" + Diffy::CSS + ".unchanged { display:none !important; } </style>" + Diffy::Diff.new(site_origin, site_now).to_s(:html)
		puts "mail -s \"changes found in #{site}\" \"#{recipient}\""
	else
		puts "no change..."
	end
	break
end