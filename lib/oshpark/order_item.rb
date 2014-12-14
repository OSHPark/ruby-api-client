module Oshpark
  class OrderItem
    def self.attrs
      %w| name batches batch_cost sub_total price quantity state confirmed_at panelized_at
          ordered_at fabbed_at shipped_at project_id panel_id order_item_option_selections |
    end

    include Model

    def project
      Oshpark::Project.find @project_id if @project_id
    end

    def panel
      Oshpark::Panel.find @panel_id if @panel_id
    end

    def order_item_option_selections
      Array(@order_item_option_selections).map do |json|
        Oshpark::OrderItemOptionSelection.from_json json
      end
    end

    def confirmed_at
      time_from @confirmed_at
    end

    def panelized_at
      time_from @panelized
    end

    def ordered_at
      time_from @ordered_at
    end

    def fabbed_at
      time_from @fabbed_at
    end

    def shipped_at
      time_from @shipped_at
    end
  end
end
