module Koine
  module Repository
    class Repository
      class RecordNotFound < RuntimeError; end

      attr_accessor :hydrator, :entity_prototype
      attr_reader :storage

      def initialize(storage)
        @storage = storage
      end

      def save(*)
        raise "Method not implemented"
      end

      def remove(*)
        raise "Method not implemented"
      end

      def find_all_by(criterias)
        hydrate_collection(storage.find_all_by(criterias))
      end

      def find_one_by(criterias)
        raw_data = storage.find_one_by(criterias)
        hydrate(raw_data, new_entity) if raw_data
      end

      def find_one_by!(criterias)
        find_one_by(criterias) or raise RecordNotFound
      end

      def hydrator
        @hydrator ||= Koine::Hydrator::Hydrator.new
      end

      def entity_prototype
        @entity_prototype or raise RuntimeError.new("Entity prototype was not set")
      end

      private

      def hydrate_collection(collection)
        [].tap do |hydrated|
          collection.each do |element|
            hydrated << hydrate(element, new_entity)
          end
        end
      end

      def hydrate(data, entity)
        hydrator.hydrate(data, entity)
        entity
      end

      def new_entity
        entity_prototype.dup
      end
    end
  end
end
