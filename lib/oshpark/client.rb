require 'openssl'
require 'json'

module Oshpark
  class Client
    attr_accessor :token, :connection

    # Create an new Client object.
    #
    # @param connection:
    # pass in a subclass of connection which implements the `request` method
    # with whichever HTTP client library you prefer.  Default is Net::HTTP.
    def initialize args = {}
      url = args.fetch(:url, "https://oshpark.com/api/v1")
      connection = args.fetch(:connection, Connection)

      self.connection = if connection.respond_to? :new
        connection.new url
      else
        connection
      end
      refresh_token
    end

    # Authenticate to the API using a email and password.
    #
    # @param email
    # @param credentials
    #   A hash with either the `with_password` or `with_api_secret` key.
    def authenticate email, credentials={}
      if password = credentials[:with_password]
        refresh_token email: email, password: password
      elsif secret = credentials[:with_api_secret]
        api_key = OpenSSL::Digest::SHA256.new("#{email}:#{secret}:#{token.token}").to_s
        refresh_token email: email, api_key: api_key
      else
        raise ArgumentError, "Must provide either `with_password` or `with_api_secret` arguments."
      end
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
      delete_request "projects/#{id}"
      true
    end

    # List all the current user's orders, and their status.
    def orders
      get_request 'orders'
    end

    # Retrieve a specific order by ID.
    #
    # @param id
    def order id
      get_request "orders/#{id}"
    end

    # Create a new Order
    def create_order
      post_request "orders"
    end

    # Add a Project to an Order
    #
    # @param id
    # @param project_id
    # @param quantity
    def add_order_item id, project_id, quantity
      put_request "orders/#{id}/add_item", {project_id: project_id, quantity: quantity}
    end

    # Set the delivery address for an Order
    #
    # @param id
    # @param address
    def set_order_address id, address
      put_request "orders/#{id}/set_address", address.to_h
    end

    # Set the delivery address for an Order
    #
    # @param id
    # @param carrier_name
    # @param service_name
    def set_order_shipping_rate id, carrier_name, service_name
      put_request "orders/#{id}/set_shipping_rate", {carrier_name: carrier_name, service_name: service_name}
    end

    # Checkout a specific order by ID.
    #
    # @param id
    def checkout_order id
      put_request "orders/#{id}/checkout"
    end

    # Cancel a specific order by ID.
    # This can only be done when the order is in the 'RECEIVED' and
    # 'AWAITING PANEL' states.
    #
    # @param id
    def cancel_order id
      delete_request "orders/#{id}"
      true
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

    # Retrieve a specific upload by ID
    #
    # @param id
    def upload id
      get_request "uploads/#{id}"
    end

    # Create an upload by passing in an IO
    #
    # @param io
    # An IO object.
    def create_upload io
      post_request "uploads", {file: io}
    end

    # Retrieve a specific import by ID
    #
    # @param id
    def import id
      get_request "imports/#{id}"
    end

    # Create an import by passing in a URL
    #
    # @param io
    # A URL
    def create_import url
      post_request "imports", {url: url}
    end

    # Do we have a currently valid API token?
    def has_token?
      !!@token
    end

    # Are we successfully authenticated to the API?
    def authenticated?
      @token && !!@token.user
    end

    private

    def connection
      @connection
    end

    def refresh_token params={}
      json = post_request 'sessions', params
      self.token = Token.from_json json['api_session_token']
      # Hey @hmaddocks - how are we going to set a timer to make the token refresh?
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
