module Feather
  class Sitemaps < Application
    def index
      @articles = Feather::Article.all(:published => true, :order => [:published_at.desc])
      xml = ::Builder::XmlMarkup.new
      xml.instruct!
      if params[:format] == "xml"
        xml.urlset :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9",
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 
          http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" do
          xml.url do
            xml.loc "http://#{request.env['HTTP_HOST']}/"
            xml.lastmod Date.today.strftime("%Y-%m-%d")
            xml.changefreq 'daily'
            xml.priority 1.0
          end
          @articles.each do |article|
            xml.url do
              xml.loc "http://#{request.env['HTTP_HOST']}#{article.permalink}"
              xml.lastmod article.published_at.strftime("%Y-%m-%d")
              age = (Date.today - Date.parse(article.published_at.to_s))
              age_old = age % (60*60*24)
              if age < 0 || age_old < 7
                xml.changefreq 'daily'
                xml.priority 0.9
              elsif age_old < 30
                xml.changefreq 'weekly'
                xml.priority 0.8
              elsif age_old < 180
                xml.changefreq 'monthly'
                xml.priority 0.5
              else
                xml.changefreq 'yearly'
                xml.priority 0.3
              end
            end
          end
        end
      else
        render :status => 404
      end
    end
  end
end