require 'net/http'
require 'uri'

class SearchEngineNotifier < Paratrooper::Notifier
  attr_reader :url

  def initialize(url)
    @url = URI(url)
    @url.path = '/sitemap.xml' if @url.path.empty?
  end

  def teardown(options = {})
    %w(www.google.com www.bing.com www.yandex.com).each do |domain|
      Net::HTTP.get(domain, '/ping?sitemap=' + URI.escape(url.to_s))
    end
  end
end
