# htail
tail http changes for new links, send response via email

# usage

* clone this repo
* install dependencies (i'm lazy)
  * `gem install httparty`
  * `gem install nokogiri`
* run `$ ruby htail.rb "<site>" <email@addr.ess>`

script monitors for changes. when it does it sends the change blocks to the address.
