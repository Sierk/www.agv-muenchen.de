xml.instruct!
xml.OpenSearchDescription xmlns: 'http://a9.com/-/spec/opensearch/1.1/', 'xmlns:moz' => 'http://www.mozilla.org/2006/browser/search/' do
  xml.ShortName 'AGV München'
  xml.Description 'Durchsuchen Sie die Homepage des Akademischen Gesangverein München'
  xml.InputEncoding 'UTF-8'
  xml.Contact 'support@baucloud.com'
  xml.Developer 'BauCloud GmbH'
  xml.Image image_path('favicon.ico'), height: 16, width: 16, type: 'image/vnd.microsoft.icon'
  # escape route helper or else it escapes the '{' '}' characters. then search doesn't work
  xml.Url type: 'text/html', method: 'get', template: "#{url_for('/search/index.html')}?q={searchTerms}"
  xml.moz :SearchForm, url_for('/search/index.html')
  xml.Url type: 'application/opensearchdescription+xml', rel: 'self', template: url_for('/opensearch.html')
end
