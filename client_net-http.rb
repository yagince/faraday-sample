require "net/http"
require "uri"
require "json"
require "pp"

res = Net::HTTP.get URI("http://localhost:4567/test")
body = JSON.parse(res)
pp body

res = Net::HTTP.post_form URI("http://localhost:4567/test"), { hoge: 100, foo: :bar }
body = JSON.parse(res.body)
pp body

uri = URI("http://localhost:4567/test.json")
req = Net::HTTP::Post.new uri, initheader = {'Content-Type' =>'application/json'}
req.body = { hoge: 100, foo: :bar }.to_json
res = Net::HTTP.start(uri.host, uri.port, use_ssl: false) do |http|
  http.request req
end
body = JSON.parse(res.body)
pp body
