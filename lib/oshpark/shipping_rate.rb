module Oshpark
  class ShippingRate

    def self.attrs
      %w| carrier_name service_name price |
    end

    include Model

  end
end
