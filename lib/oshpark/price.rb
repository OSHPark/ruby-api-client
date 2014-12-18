module Oshpark
  class Price

    def self.attrs
      %w| width_in_mils height_in_mils pcb_layers quantity quantity_multiple minimum_quantity minimum_square_inches batches batch_cost subtotal |
    end

    include Model

    def self.price_for width, height, layers
      json = Oshpark::client.pricing width, height, layers
      from_json json['pricing']
    end
  end
end
