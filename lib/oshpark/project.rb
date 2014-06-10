module Oshpark
  class Project
    def self.attrs
      %w| id design_file_url name description top_image bottom_image width_in_mils height_in_mils pcb_layers state layers |
    end

    def self.write_attrs
      %w| name description |
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

    def width_in_mils
      @width_in_mils || 0
    end

    def height_in_mils
      @height_in_mils || 0
    end

    def reload!
      client.project id
    end

    def approve!
      client.approve_project id
    end

    def destroy!
      client.destroy_project id
    end

  end
end
