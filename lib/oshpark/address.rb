module Oshpark
  class Address
    REQUIRED_ARGS = %w|name address_line_1 address_line_2 city country|
    def self.attrs
      %w| name company_name address_line_1 address_line_2 city state zip_or_postal_code country phone_number is_business |
    end

    include Model

    attrs.each {|a| attr_accessor a }

    def initialize args={}
      clean_json args do |json|
        check_args json
        reload_with json
      end
    end

    def to_h
      {}.tap do |hash|
        Address.attrs.each do |a|
          hash[a] = public_send a
        end
      end
    end

    def available_shipping_rates
      ShippingRates.rates_for_address self
    end

    private

    def check_args args
      unless (args.keys.map(&:to_s) & REQUIRED_ARGS) == REQUIRED_ARGS
        raise ArgumentError, "Missing required arguments #{(REQUIRED_ARGS - args.keys).join(' ')}"
      end
      args
    end

  end
end
