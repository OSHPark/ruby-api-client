module Oshpark
  class ShippingRate

    def self.attrs
      %w| carrier_name service_name price |
    end

    include Model

    def self.rates_for_address address
      json = Oshpark::client.shipping_rates address.to_h

      json['shipping_rates'].collect do |shipping_rate_json|
        from_json shipping_rate_json
      end
    end
  end
end
