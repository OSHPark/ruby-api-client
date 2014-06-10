module Oshpark
  module Model

    def initialize json
      json.each do |key,value|
        instance_variable_set "@#{key}", value
      end
      @dirty_attributes = []
    end

    def dirty?
      @dirty_attributes.size > 0
    end

    def save!
      attrs = {}
      @dirty_attributes.map do |attr|
        attrs[attr] = public_send(attr)
      end
      our_name = self.class.to_s.split('::').last.downcase
      client.public_send("update_#{our_name}", id, attrs)
    end

    def self.included base
      base.send :extend, ClassMethods
      base.instance_eval do
        attr_reader *base.attrs
        attr_accessor:client
      end
      base.write_attrs.each do |attr|
        define_method "#{attr}=" do |new_value|
          @dirty_attributes << attr
          instance_variable_set "@#{attr}".to_sym, new_value
        end
      end if base.respond_to? :write_attrs
    end

    module ClassMethods
      def from_json json, client=nil
        model = self.new json
        model.client = client
        model
      end

      def attrs
        []
      end
    end

  end
end
