module Oshpark
  module Dimensionable
    def width_in_inches
      width_in_mils / 1000.0
    end

    def height_in_inches
      height_in_mils / 1000.0
    end

    def area_in_square_inches
      width_in_inches * height_in_inches
    end

    def width_in_mm
      width_in_inches * 25.4
    end

    def height_in_mm
      height_in_inches * 25.4
    end

    def area_in_square_mm
      width_in_mm * height_in_mm
    end
  end
end
