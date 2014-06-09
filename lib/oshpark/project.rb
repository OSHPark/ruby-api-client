module Oshpark
  class Project
    def self.attrs
      %w| id design_file_url name description top_image bottom_image width_in_mils height_in_mils pcb_layers state layers |
    end
    include Model
    include Dimensionable

    def top_image
      Image.from_json @top_image
    end

    def bottom_image
      Image.from_json @bottom_image
    end

    def layers
      @layers.map do |json|
        Layer.from_json json
      end
    end

    def short_description
      layers = 'two'  if pcb_layers == 2
      layers = 'four' if pcb_layers == 4
      "#{size_in_locale} #{layers} layer board"
    end

    def size_in_locale
      if metric?
        "%0.2fx%0.2fmm" % [width_in_mm, height_in_mm]
      else
        "%0.2fx%0.2f\"" % [width_in_inches, height_in_inches]
      end
    end

    def width_in_mils
      @width_in_mils || 0
    end

    def height_in_mils
      @height_in_mils || 0
    end

    private

    def metric?
      NSLocale.currentLocale.objectForKey NSLocaleUsesMetricSystem
    end

    def imperial?
      !metric?
    end

  end
end
