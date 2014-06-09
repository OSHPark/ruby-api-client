module Oshpark
  module Model

    def self.included base
      base.send :extend, ClassMethods
      base.instance_eval do
        attr_accessor *base.attrs, :client
      end
    end

    module ClassMethods
      def from_json json, client=nil
        model = self.new
        model.client = client
        attrs.each do |attr|
          model.public_send "#{attr}=", json[attr]
        end
        model
      end

      def attrs
        []
      end
    end

  end
end
