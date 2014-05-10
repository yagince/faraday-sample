require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/json"

get "/test" do
  require "pp"
  pp params
  json name: :hoge, age: 100
end

post "/test" do
  json params
end

post "/test.json" do
  json JSON.parse(request.body.read)
end
