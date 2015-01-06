require 'json'
require 'uri'
require 'net/http'
require 'micro_token'

module Oshpark
  HttpError     = Class.new RuntimeError
  Unauthorized  = Class.new HttpError
  NotFound      = Class.new HttpError
  ServerError   = Class.new HttpError
  Unprocessable = Class.new HttpError

  class Connection
    def initialize endpoint_url
      self.api_endpoint = endpoint_url
    end

    def request method, endpoint, params={}, token
      method = method[0].upcase + method[1..-1]
      uri = uri_for endpoint

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.port == 443

      request = Net::HTTP.const_get(method).new(uri.path)

      default_headers(token).each do |header, value|
        request[header] = value
      end

      if params.keys.include? :file
        boundary = MicroToken.generate 20
        request.body   = "--#{boundary}\r\n" +
                         params.to_multipart.join('--' + boundary + "\r\n") +
                         "--#{boundary}--\r\n"
        request['Content-Type'] = "multipart/form-data; boundary=#{boundary}"

      else
        request.body = params.to_query
      end

      response = http.request(request)

      json = if response.body.size >= 2
               JSON.parse(response.body)
             else
               {}
             end

      case response.code.to_i
      when 401
        raise Unauthorized,  json['error']
      when 404
        raise NotFound,      json['error']
      when 422
        raise Unprocessable, json['error']
      when 400...499
        raise HttpError,     json['error']
      when 500...599
        raise ServerError,   json['error']
      end

      json

    rescue JSON::ParserError => e
      raise ServerError,  "Bad response from server: #{e.message}"
    end

    private

    attr_accessor :api_endpoint

    def uri_for endpoint
      URI("#{api_endpoint}/#{endpoint}")
    end

    def default_headers token=nil
      header = {
        'Accept'       => 'application/json',
        # 'Content-Type' => 'application/json'
      }
      header['Authorization'] = token.token if token
      header
    end

    def prepare_params params
      if params.keys.include? :file
        params.to_multipart
      else
        params.to_query
      end
    end
  end
end
