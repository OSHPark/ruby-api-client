require 'time'

module Oshpark
  module RemoteModel

    def save!
      attrs = {}
      @dirty_attributes.map do |attr|
        attrs[attr] = public_send(attr)
      end

      Oshpark::client.public_send("update_#{object_name}", id, attrs)
    end

    def reload!
      json = Oshpark::client.public_send(object_name, id)
      reload_with json
    end

    def destroy!
      Oshpark::client.public_send("destroy_#{object_name}", id)
      nil
    end

    module ClassMethods
      def all
        Oshpark::client.public_send(object_names)[object_names].map do |json|
          self.from_json json
        end
      end

      def find id
        self.from_json(Oshpark::client.public_send(object_name, id)[object_name])
      end
    end
  end
end
