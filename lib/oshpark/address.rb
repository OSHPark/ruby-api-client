module Oshpark
  class Address
    REQUIRED_ARGS = %w|name address_line_1 address_line_2 city country|
    def self.attrs
      %w| name company_name address_line_1 address_line_2 city state zip_or_postal_code country phone_number is_business |
    end

    include Model

    attrs.each {|a| attr_accessor a }

    def initialize args={}
      super check_args args
    end

    def to_h
      {}.tap do |hash|
        Address.attrs.each do |a|
          hash[a] = public_send a
        end
      end
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
