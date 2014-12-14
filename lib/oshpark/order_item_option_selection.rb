module Oshpark
  class OrderItemOptionSelection
    def self.attrs
      %w| id name price |
    end

    include Model
  end
end
