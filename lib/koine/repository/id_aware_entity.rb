module Koine
  module Repository
    module IdAwareEntity
      def find(id)
        data = adapter.find_one_by(id: id)
        return data unless data
        entity = new_entity
        hydrate(data, entity)
        entity
      end

      def create(entity)
        values = hydrator.extract(entity)
        values.delete("id")
        values.delete(:id)
        entity.id = adapter.insert(values)
      end

      def update(entity)
        values = hydrator.extract(entity)
        values.delete(:id)
        adapter.update_where({ id: entity.id }, values)
      end
    end
  end
end
