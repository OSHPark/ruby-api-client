module Oshpark
  class Image
    def self.attrs
     %w| thumb_url large_url original_url |
    end

    include Model
  end
end
