require "faraday"
require "faraday_middleware"
require "json"
require "pp"

res = Faraday.new(:url => "http://localhost:4567").get("/test")
body = JSON.parse res.body
pp body

client = Faraday.new(:url => "http://localhost:4567")
res = client.post "/test", { hoge: 100, foo: :bar }
body = JSON.parse res.body
pp body

client = Faraday.new(:url => "http://localhost:4567")
res = client.post do |req|
  req.url '/test.json'
  req.headers['Content-Type'] = 'application/json'
  req.body = { hoge: 100, foo: :bar }.to_json
end
body = JSON.parse res.body
pp body


client = Faraday.new(:url => "http://localhost:4567") do |faraday|
  faraday.request :json
  faraday.response :logger
  faraday.adapter  Faraday.default_adapter
end
res = client.post "/test.json", { hoge: 100, foo: :bar }
body = JSON.parse res.body
pp body

require 'logger'
class BodyDumper
  def initialize app
    @app = app
    @logger = Logger.new(STDOUT)
  end

  def call env
    dump_body("request", env)
    @app.call(env).on_complete do
      dump_body("response", env)
    end
  end

  private
  def dump_body phase, env
    @logger.info("#{phase} : #{env.body}") if env.body
  end
end

client = Faraday.new(:url => "http://localhost:4567") do |faraday|
  faraday.request  :url_encoded
  faraday.use BodyDumper
  faraday.adapter  Faraday.default_adapter
end
res = client.post "/test", { hoge: 100, foo: :bar }
