module Oshpark
  class Panel
    def self.attrs
      %w| pcb_layers scheduled_order_time expected_receive_time
          id ordered_at received_at state service total_orders
          total_boards board_area_in_square_mils |
    end

    include Model

    def scheduled_order_time
      time_from @scheduled_order_time if @scheduled_order_time
    end

    def expected_receive_time
      time_from @expected_receive_time if @expected_receive_time
    end

    def ordered_at
      time_from @ordered_at if @ordered_at
    end

    def received_at
      time_from @received_at if @received_at
    end

  end
end
