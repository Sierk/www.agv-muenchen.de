# encoding: utf-8

ENV['RACK_ENV'] ||= 'development'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

NewRelic::Agent.after_fork(:force_reconnect => true)
require 'new_relic/agent/instrumentation/rack'

require 'rack/contrib/try_static'

Airbrake.configure do |config|
  config.api_key = ENV['HOPTOAD_API_KEY']
  config.host    = 'errbit.baucloud.com'
  config.port    = 80
  config.secure  = config.port == 443
end

use Rack::Deflater

use Airbrake::Rack

use Rack::Rewrite do
  r301 %r{.*}, 'https://www.agv-muenchen.de$&', scheme: 'http'

  r301 '/favicon.ico', '/images/favicon.ico'
  r301 '/kontakt/impressum/', '/impressum/'
  r301 '/musik-und-theater/junges-theater/improvisationstheater/', '/musik-und-theater/improvisationstheater/'
end

# Serve static files under a `build` directory:
# - `/` will try to serve your `build/index.html` file
# - `/foo` will try to serve `build/foo` or d`build/foo.html` in that order
# - missing files will try to serve build/404.html or a tiny default 404 page

Rack::TryStatic.send :include, ::NewRelic::Agent::Instrumentation::Rack
use Rack::TryStatic,
    root: 'build',
    urls: %w[/],
    try: %w(.html index.html /index.html),
    header_rules: [
      # Cache all static files in public caches (e.g. Rack::Cache)
      #  as well as in the browser
      [:all, { 'Cache-Control' => 'public' }],
      [/\.(?:css|eot|gif|ico|jpeg|jpg|js|otf|png|svg|svgz|ttf|woff)\z/, { 'Cache-Control' => 'public, max-age=3153600' }],

      # Provide web fonts with cross-origin access-control-headers
      #  Firefox requires this when serving assets using a Content Delivery Network
      [:fonts, { 'Access-Control-Allow-Origin' => '*' }]
    ]

# Run your own Rack app here or use this one to serve 404 messages:
run lambda { |env|
  not_found_page = File.expand_path('../build/404/index.html', __FILE__)
  if File.exist?(not_found_page)
    [ 404, { 'Content-Type'  => 'text/html; charset=utf-8'}, [File.read(not_found_page)] ]
  else
    [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ]
  end
}
