module Oshpark
  class Order

    def self.attrs
      %w| id board_cost cancellation_reason cancelled_at ordered_at
          payment_provider payment_received_at project_name quantity
          shipping_address shipping_cost shipping_country
          shipping_method shipping_name state total_cost project_id
          panel_id |
    end

    include Model

    def self.create
      self.from_json(Oshpark::client.create_order)
    end

    def add_item order_item, quantity
      json = Oshpark::client.add_order_item id, order_item.id, quantity
      reload_with json
    end

    def set_address address
      json = Oshpark::client.set_order_address id, address
      reload_with json
    end

    def set_shipping_rate carrier_name, service_name
      json = Oshpark::client.set_order_shipping_rate id, carrier_name, service_name
      reload_with json
    end

    def checkout
      json = Oshpark::client.checkout_order id
      reload_with json
    end

    def panel
      Panel.find panel_id
    end

    def project
      Project.find project_id
    end

    def cancelled_at
      time_from @cancelled_at
    end

    def ordered_at
      time_from @ordered_at
    end

    def payment_received_at
      time_from @payment_received_at
    end
  end
end
