require 'httparty'
require 'nokogiri'
require 'twilio-ruby'

account_sid = 'AC9c158c2a5577f0a696a9f4e8726f5f97'
auth_token = '1b698b64546a2d127314083126221a6c'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

# alternatively, you can preconfigure the client like so
Twilio.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
@client = Twilio::REST::Client.new

@client.messages.create(
  from: '+14159341234',
  to: '+16105557069',
  body: 'Hey there!'
)

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
		(`echo "#{links}" | mailx -s "#{site} update at #{now}" #{recipient}`) if links != '[]'
		site_origin = site_now
	end
end
