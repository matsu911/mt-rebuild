require "mt/rebuild/version"

module MT
  class Rebuild
    def initialize(host)
      @conn = Faraday.new(:url => host) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get_access_token(user, pass, cgi_path)
      res = @conn.post do |req|
        req.url "/#{cgi_path}/mt-data-api.cgi/v1/authentication"
        req.params['username'] = user
        req.params['password'] = pass
        req.params['remember'] = ''
        req.params['clientId'] = 'faraday'
      end
      JSON.parse(res.body)['accessToken']
    end

    def rebuild_pages(token, cgi_path, ids, url=nil)
      res = @conn.get do |req|
        if url
          req.url "/#{cgi_path}/mt-data-api.cgi/v1/#{url}"
        else
          req.url "/#{cgi_path}/mt-data-api.cgi/v1/publish/entries"
          req.params['ids'] = ids.join(',')
        end
        req.headers['X-MT-Authorization'] = "MTAuth accessToken=#{token}"
        req.options.timeout = 120
      end
      # p res.body
      data = JSON.parse res.body
      puts "#{data['startTime']} #{data['status']} "
      # p res.headers
      if res.headers['x-mt-next-phase-url']
        puts res.headers['x-mt-next-phase-url']
        sleep 5
        rebuild_pages(token, host, cgi_path, ids, res.headers['x-mt-next-phase-url'])
      end
    end

    def entry_ids(cgi_path, id)
      res = @conn.get do |req|
        req.url "/#{cgi_path}/mt-data-api.cgi/v1/sites/#{id}/entries"
        req.params['limit'] = 1000
        req.options.timeout = 120
      end
      data = JSON.parse res.body
      data['items'].map{ |x| x['id'] }
    end

    def page_ids(cgi_path, id)
      res = @conn.get do |req|
        req.url "/#{cgi_path}/mt-data-api.cgi/v1/sites/#{id}/pages"
        req.params['limit'] = 1000
        req.options.timeout = 120
      end
      data = JSON.parse res.body
      p data
      data['items'].map{ |x| x['id'] }
    end

    def blog_ids(cgi_path, id)
      res = @conn.get do |req|
        req.url "/#{cgi_path}/mt-data-api.cgi/v1/users/#{id}/sites"
        req.params['limit'] = 1000
        req.options.timeout = 120
      end
      data = JSON.parse res.body
      data['items'].map{ |x| x['id'] }
    end

    def apply_theme(token, cgi_path, id, theme_id)
      res = @conn.post do |req|
        req.url "/#{cgi_path}/mt-data-api.cgi/v1/sites/#{id}/theme"
        req.params['theme_id'] = theme_id
        req.options.timeout = 120
        req.headers['X-MT-Authorization'] = "MTAuth accessToken=#{token}"
      end
      p res.body
    end
  end
end
