require 'net/http'
require 'json'
module ApplicationHelper
  params = {
    api_key: "APIKEY",
    query: "QUERY",
    country_code: "COUNTRY_CODE",
    tld: "TLD"
  }
  uri = URI('https://api.scraperapi.com/structured/google/search')
  uri.query = URI.encode_www_form(params)
  website_content = Net::HTTP.get(uri)
  print(website_content)
end
