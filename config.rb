ENV['RACK_ENV'] ||= 'development'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

###
# Blog settings
###

set :time_zone, 'Berlin'

activate :blog do |blog|
  blog.prefix = 'blog'
  # blog.permalink = ':year/:month/:day/:title.html'
  # blog.sources = ':year-:month-:day-:title.html'
  # blog.taglink = 'tags/:tag.html'
  blog.layout = 'blog'
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ':year.html'
  # blog.month_link = ':year/:month.html'
  # blog.day_link = ':year/:month/:day.html'
  # blog.default_extension = '.md'

  blog.tag_template = 'blog/tag.html'
  blog.calendar_template = 'blog/calendar.html'

  blog.paginate = true
  blog.per_page = 10
  # blog.page_link = 'page/:num'
end

page '/blog/feed.xml', layout: false

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

page '/404.html', layout: :base_with_nav
page '/index.html', layout: :base_with_nav
page '/opensearch.xml', layout: false
page '/sitemap.xml', layout: false

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

require 'lib/lightbox_helpers'
helpers LightboxHelpers
helpers do
  def nav_parent_active?(page)
    active = current_page.url == page
    active = current_page.parent.url == page unless active || current_page.parent.nil? || current_page.parent.url == '/'
    active ? { class: 'active' } : {}
  end

  def nav_active?(page)
    current_page.url == page ? { class: 'active' } : {}
  end

  def head_title
    first = if content_for? :head_title
              yield_content :title
            elsif content_for? :title
              yield_content :title
            elsif current_page.data.title
              current_page.data.title
            end

    [first, 'AGV München'].join(' | ')
  end

  def body_id
    if current_page.data.body.present?
      current_page.data.body[:id]
    elsif content_for? :body_id
      yield_content :body_id
    end
  end

  def body_class
    current_page.data.body[:class] if current_page.data.body.present?
  end

  def breadcrumbs
    return if current_page.data.breadcrumb === false
    items = []

    p = current_page

    while p = p.parent
      content = content_tag :li, itemscope: '', itemtype: 'http://data-vocabulary.org/Breadcrumb' do
        link_to p.url, title: p.data.title, itemprop: 'url' do
          content_tag :span, (p.data.breadcrumb && p.data.breadcrumb.title) || p.data.title, itemprop: 'title'
        end
      end

      items.unshift content
    end

    content = content_tag :span, (current_page.data.breadcrumb && current_page.data.breadcrumb.title) || current_page.data.title, itemprop: 'title'
    items.push content_tag :li, content, class: 'active', itemscope: '', itemtype: 'http://data-vocabulary.org/Breadcrumb'

    content_tag :ol, items.join, class: 'breadcrumb'
  end

  def body_title?
    content_for?(:body_title) || content_for?(:title) || current_page.data.title
  end

  def body_title
    if content_for? :body_title
      yield_content :body_title
    elsif content_for? :title
      yield_content :title
    elsif current_page.data.title
      current_page.data.title
    end
  end

  def author(resource = current_page)
    if data.authors && resource.data.author
      data.authors[resource.data.author]
    else
      Thor::CoreExt::HashWithIndifferentAccess.new
    end
  end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :i18n, mount_at_root: :de

activate :directory_indexes

# Enable cache buster
activate :asset_hash, ignore: [%r{^blog}]

#set :markdown, tables: true, autolink: true, gh_blockcode: true, fenced_code_blocks: true, with_toc_data: true
#set :markdown_engine, :redcarpet

configure :development do
  # Reload the browser automatically whenever files change
  activate :livereload
  use Rack::LiveReload
  config[:file_watcher_ignore] += [ /.idea\// ]

  activate :google_analytics do |ga|
    ga.tracking_id = false
  end
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css,
           inline: true

  # Minify Javascript on build
  require 'uglifier'
  activate :minify_javascript,
           compressor: ::Uglifier.new(output: { comments: :none }),
           inline: true

  activate :minify_html,
           remove_input_attributes: false

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_path, "/Content/images/"

  if ENV['ASSET_HOST_URL'].present?
    activate :asset_host
    set :asset_host do
      ENV['ASSET_HOST_URL']
    end
  end

  activate :google_analytics do |ga|
    ga.tracking_id = ENV['GOOGLE_ANALYTICS_ID']
    ga.anonymize_ip = true
    ga.debug = false
  end
end
