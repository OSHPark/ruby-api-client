require 'json'

module Oshpark
  class Client
    attr_accessor :token, :connection

    # Create an new Client object.
    #
    # @param connection:
    # pass in a subclass of connection which implements the `request` method
    # with whichever HTTP client library you prefer.  Default is Net::HTTP.
    def initialize url: "https://oshpark.com/api/v1", connection: Connection
      self.connection = connection.new url
      refresh_token
    end

    # Authenticate to the API using a username and password.
    #
    # @param username
    # @param password
    def authenticate username, password
      refresh_token username: username, password: password
    end

    # Retrieve a list of projects for the current user.
    def projects
      get_request 'projects'
    end

    # Retrieve a particular project from the current user's collection by ID.
    #
    # @param id
    def project id
      get_request "projects/#{id}"
    end

    # Approve a particular project from the current user's collection by ID.
    # We strongly suggest that you allow the user to view the rendered images
    # in Project#top_image, Project#bottom_image and Project#layers[]#image
    # You should probably call Project#approve! instead.
    #
    # @param id
    def approve_project id
      get_request "projects/#{id}/approve"
    end

    # Update a project's data.
    #
    # @param id
    # @param attrs
    # A hash of attributes to update.
    def update_project id, attrs
      put_request "projects/#{id}", project: attrs
    end

    # Destroy a particular project from the current user's collection by ID.
    #
    # @param id
    def destroy_project id
      delete_request "projects/#{id}" do
        true
      end
    end

    # List all the current user's orders, and their status.
    def orders
      get_request 'orders' do |json|
        json['orders'].map do |order_json|
          Order.from_json order_json, self
        end
      end
    end

    # Retrieve a specific order by ID.
    #
    # @param id
    def order id
      get_request "orders/#{id}" do |json|
        Order.from_json json['order'], self
      end
    end

    # Cancel a specific order by ID.
    # This can only be done when the order is in the 'RECEIVED' and
    # 'AWAITING PANEL' states.
    #
    # @param id
    def cancel_order id
      delete_request "orders/#{id}"
    end

    # List all currently open and recently closed panels, including some
    # interesting information about them.
    def panels
      get_request "panels"
    end

    # Retrieve a specific panel by ID.
    #
    # @param id
    def panel id
      get_request "panels/#{id}"
    end

    # Do we have a currently valid API token?
    def has_token?
      !!@token
    end

    # Are we successfully authenticated to the API?
    def authenticated?
      @token && !!@token.user
    end

    # Override hook for converting JSON serialized time strings into Ruby
    # Time objects.  Only needed if `Time.parse` doesn't work as expected
    # on your platform (ie RubyMotion).
    def time_from json_time
      Time.parse json_time if json_time
    end

    private

    def connection
      @connection
    end

    def refresh_token params={}
      json = post_request 'sessions', params
      self.token = Token.from_json json['api_session_token']
    end

    def post_request endpoint, params={}
      connection.request :post, endpoint, params, token
    end

    def put_request endpoint, params={}
      connection.request :put, endpoint, params, token
    end

    def get_request endpoint, params={}
      connection.request :get, endpoint, params, token
    end

    def delete_request endpoint, params={}
      connection.request :delete, endpoint, params, token
    end
  end

end
