require 'json'

module Oshpark
  class Connection
    def initialize endpoint_url
      self.api_endpoint = endpoint_url
    end

    def request method, endpoint, params={}
      method = method[0].upcase + method[1..-1]
      uri = uri_for endpoint

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.port == 443

      request = Net::HTTP.const_get(method).new(uri.path)

      default_headers.each do |header, value|
        request[header] = value
      end

      response = http.request(request)

      json = JSON.parse(response.body)

      case response.code.to_i
      when 401
        raise Unauthorized, json['error']
      when 404
        raise NotFound,     json['error']
      when 500...599
        raise ServerError,  json['error']
      end

      yield json
    end

    private

    attr_accessor :api_endpoint

    def uri_for endpoint
      URI("#{api_endpoint}/endpoint")
    end

    def default_headers
      header = {
        'Accept'       => 'application/json',
        # 'Content-Type' => 'application/json'
      }
      header['Authorization'] = @token.token if @token
      header
    end
  end
end
