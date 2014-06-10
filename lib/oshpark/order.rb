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
