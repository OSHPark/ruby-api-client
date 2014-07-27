require 'time'

module Oshpark
  module Model

    def initialize json
      reload_with json
    end

    def dirty?
      @dirty_attributes.size > 0
    end

    def save!
      attrs = {}
      @dirty_attributes.map do |attr|
        attrs[attr] = public_send(attr)
      end

      Oshpark::client.public_send("update_#{object_name}", id, attrs)
    end

    def reload!
      json = Oshpark::client.public_send(object_name, id)[object_name]
      reload_with json
    end

    def destroy!
      Oshpark::client.public_send("destroy_#{object_name}", id)[object_name]
      nil
    end

    def self.included base
      base.send :extend, ClassMethods

      base.instance_eval do
        attr_reader *base.attrs
      end

      base.write_attrs.each do |attr|
        define_method "#{attr}=" do |new_value|
          @dirty_attributes << attr unless @dirty_attributes.include?(attr)
          instance_variable_set "@#{attr}".to_sym, new_value
        end
      end if base.respond_to? :write_attrs
    end

    module ClassMethods
      def from_json json
        model = self.new json
        model
      end

      def attrs
        []
      end

      def all
        Oshpark::client.public_send(object_names)[object_names].map do |json|
          self.from_json json
        end
      end

      def find id
        self.from_json(Oshpark::client.public_send(object_name, id)[object_name])
      end

      def object_name
        self.name.split('::').last.downcase
      end

      def object_names
        "#{object_name}s"
      end

    end

    private
    # Override hook for converting JSON serialized time strings into Ruby
    # Time objects.  Only needed if `Time.parse` doesn't work as expected
    # on your platform (ie RubyMotion).
    def time_from json_time
      Time.parse json_time if json_time
    end

    def object_name
      self.class.object_name
    end

    def object_names
      self.class.object_names
    end

    def reload_with json
      json.each do |key,value|
        instance_variable_set "@#{key}", value
      end
      @dirty_attributes = []
    end

  end
end
