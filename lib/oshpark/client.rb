require 'json'

module Oshpark
  class Client
    Unauthorized = Class.new(RuntimeError)
    NotFound     = Class.new(RuntimeError)
    ServerError  = Class.new(RuntimeError)

    attr_accessor :token, :connection

    def initialize connection: Connection.new(endpoint_url = "https://oshpark.com/api/v1")
      self.connection = connection
      refresh_token
    end

    def authenticate username, password
      refresh_token username: username, password: password
    end

    def projects
      get_request 'projects' do |json|
        json['projects'].map do |project_json|
          Project.from_json project_json, self
        end
      end
    end

    def project id
      get_request "projects/#{id}" do |json|
        Project.from_json json['project'], self
      end
    end

    def orders
      get_request 'orders' do |json|
        json['orders'].map do |order_json|
          Order.from_json order_json, self
        end
      end
    end

    def order id
      get_request "orders/#{id}" do |json|
        Order.from_json json, self
      end
    end

    def panels
      get_request "panels" do |json|
        json['panels'].map do |panel_json|
          Panel.from_json panel_json, self
        end
      end
    end

    def panel id
      get_request "panels/#{id}" do |json|
        Panel.from_json json, self
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

    def connection
      @connection
    end

    def refresh_token params={}
      post_request 'sessions', params do |json|
        self.token = Token.from_json json['api_session_token'], self
      end
    end

    def post_request endpoint, params={}, &block
      connection.request :post, endpoint, params, &block
    end

    def get_request endpoint, params={}, &block
      connection.request :get, endpoint, params, &block
    end
  end

end
