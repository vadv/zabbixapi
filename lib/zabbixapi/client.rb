require 'json'
require 'net/http'

class ZabbixApi
  class Client

    def api_url
      @options[:url]
    end

    def api_user
      @options[:user]
    end

    def api_passwd
      @options[:password]
    end

    def debug
      @options[:debug]
    end

    def uri
      URI.parse(api_url)
    end

    def id
      @request_id = @request_id + 1
    end

    def initialize(options = {})
      @options = options
      @request_id  = 0
      #auth ? true : nil
    end

    def message_json(body)
      message = {
        'jsonrpc' => '2.0',
        'method'  => body[:method],
        'params'  => body[:params],
        'auth'    => auth,
        'id'      => id
      }
      JSON.generate(message)
    end

    def auth_json
      message = {
        'jsonrpc' => '2.0',
        'method'  => 'user.login',
        'params'  => {
          'user'      => api_user,
          'password'  => api_passwd,
        },
        'id' => id
      }
      JSON.generate(message)
    end

    def http_request(body)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field('Content-Type', 'application/json-rpc')
      request.body = body
      response = http.request(request)
      raise "HTTP Error: #{response.code} on #{api_url}" unless response.code == "200"
      puts "[DEBUG] Get answer: #{response.body}" if debug
      response.body
    end

    def _request(body)
      puts "[DEBUG] Send request: #{body}" if debug
      result = JSON.parse(http_request(body))
      raise "Server answer API error: #{result['error'].inspect} on request: #{body}" if result['error']
      result['result']
    end

    def api_request(body)
      _request message_json(body)
    end

    def auth
      _request auth_json
    end

  end
end



