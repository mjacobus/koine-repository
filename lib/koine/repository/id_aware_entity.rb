module Koine
  module Repository
    module IdAwareEntity
      def find(id)
        data = storage.find_one_by(id: id)
        return data unless data
        entity = new_entity
        hydrate(data, entity)
        entity
      end

      def create(entity)
        values = hydrator.extract(entity)
        values.delete("id")
        values.delete(:id)
        entity.id = storage.insert(values)
      end

      def update(entity)
        values = hydrator.extract(entity)
        values.delete(:id)
        storage.update_where({ id: entity.id }, values)
      end
    end
  end
end
