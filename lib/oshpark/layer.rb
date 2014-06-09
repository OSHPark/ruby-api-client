module Oshpark
  class Layer
    def self.attrs
      %w| id name gerber_file_url image imported_from width_in_mils height_in_mils |
    end
    include Model

    def image
      Image.from_json @image
    end

  end
end
