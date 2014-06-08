require 'json'

module Oshpark
  class Client
    Unauthorized = Class.new(RuntimeError)
    NotFound     = Class.new(RuntimeError)
    ServerError  = Class.new(RuntimeError)

    attr_accessor :token, :api_endpoint

    def initialize endpoint_url="https://oshpark.com/api/v1"
      self.api_endpoint = endpoint_url
      refresh_token
    end

    def authenticate username, password
      refresh_token username: username, password: password
    end

    def projects
      get_request 'projects' do |json|
        json['projects'].map do |project_json|
          Project.fromJSON project_json, self
        end
      end
    end

    def project id
      get_request "projects/#{id}" do |json|
        Project.fromJSON json['project'], self
      end
    end

    def orders
      get_request 'orders' do |json|
        json['orders'].map do |order_json|
          Order.fromJSON order_json, self
        end
      end
    end

    def order id
      get_request "orders/#{id}" do |json|
        Order.fromJSON json, self
      end
    end

    def panels
      get_request "panels" do |json|
        json['panels'].map do |panel_json|
          Panel.fromJSON panel_json, self
        end
      end
    end

    def panel id
      get_request "panels/#{id}" do |json|
        Panel.fromJSON json, self
      end
    end

    def has_token?
      !!@token
    end

    def authenticated?
      @token && !!@token.user
    end

    def time_from json_time
      Time.parse json_time if json_time
    end

    private

    def refresh_token params={}
      post_request 'sessions', params do |json|
        self.token = Token.fromJSON json['api_session_token'], self
      end
    end

    def post_request endpoint, params={}, &block
      request :post, endpoint, params, &block
    end

    def get_request endpoint, params={}, &block
      request :get, endpoint, params, &block
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
    end

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
