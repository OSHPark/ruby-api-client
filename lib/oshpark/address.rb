module Oshpark
  class Address
    def self.attrs
      %i| name company_name address_line_1 address_line_2 city state zip_or_postal_code country phone_number is_business |
    end

    attrs.each {|a| attr_accessor a }

    def initialize *args
      Address.attrs.each do |a|
        v = args.first.fetch(a, nil)
        public_send :"#{a}=", v
      end
    end

    def to_h
      {}.tap do |hash|
        Address.attrs.each do |a|
          hash[a] = public_send a
        end
      end
    end

  end
end
