xml.instruct!
xml.urlset 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  sitemap.resources.each do |resource|
    xml.url do
      xml.loc URI.join(data.site.url, resource.url)
      xml.lastmod DateTime.now.to_time.iso8601
      changefreq = 'monthly'
      priority = '0.5'
      unless resource.data.seo.nil?
        changefreq = resource.data.seo.changefreq unless resource.data.seo.changefreq.nil?
        priority = resource.data.seo.priority unless resource.data.seo.priority.nil?
      end
      xml.changefreq changefreq
      xml.priority priority
    end if resource.url !~ /\.(css|js|eot|svg|woff|otf|ttf|png|jpg|gif|ico)$/ && (resource.data.seo.present? ? resource.data.seo.priority.to_f > 0 : true)
  end
end
