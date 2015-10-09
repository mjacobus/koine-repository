module Koine
  module Hydrator
    class Hydrator

      def hydrate(data, object)
        data.each do |key, value|
          method = "#{key}="
          object.send(method, value) if object.respond_to?(method)
        end
      end

      def extract(object)
        data  = {}

        entity_methods(object).reject do |method|
          if object.method(method).arity == 0
            data[method] = object.send(method)
          end
        end

        data
      end

      private

      def entity_methods(object)
        object_methods = Object.public_instance_methods

        object.public_methods(true).reject do
          |method| object_methods.include?(method)
        end
      end
    end
  end
end
