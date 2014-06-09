module Oshpark
  class Image
    attr_accessor :thumb_url, :large_url, :original_url

    def self.from_json json
      image = self.new
      image.thumb_url    = json['thumb_url']
      image.large_url    = json['large_url']
      image.original_url = json['original_url']
      image
    end
  end
end
