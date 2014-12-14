module Oshpark
  class OrderOption
    def self.attrs
      %w| id name description price |
    end

    include Model
  end
end
