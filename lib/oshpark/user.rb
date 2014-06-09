module Oshpark
  class User
    def self.attrs
      %w| id |
    end

    include Model
  end
end
