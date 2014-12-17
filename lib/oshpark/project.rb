module Oshpark
  class Project
    STATES = %w| NEW APPROVED AWAITING_REMOVAL |

    def self.attrs
      %w| id design_file_url name description top_image bottom_image width_in_mils height_in_mils pcb_layers state layers order_options is_shared |
    end

    def self.write_attrs
      %w| name description |
    end

    include Model
    include Stateful
    include Dimensionable

    alias shared? is_shared

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

    def order_options
      @order_options.map do |json|
        OrderOption.from_json json
      end
    end

    def width_in_mils
      @width_in_mils || 0
    end

    def height_in_mils
      @height_in_mils || 0
    end

    def approve!
      json = Oshpark::client.approve_project id
      reload_with(json['project'])
    end

  end
end
