module Koine
  module Repository
    module Persistence
      class Adapter
        class Sql < Adapter
          attr_reader :adapter, :table_name, :table, :id_field

          def initialize(adapter, table_name, id_field = :id)
            @adapter = adapter
            @table_name = table_name
            @table = adapter[table_name]
            @id_field = id_field
          end

          def exists?(criterias)
            table.where(criterias).limit(2).count > 0
          end

          def find(id)
            find_one_by(id_field => id)
          end

          def find_one_by(criterias)
            table.where(criterias).first
          end

          def find_all_by(criterias)
            table.where(criterias)
          end

          def insert(values)
            table.insert(values)
          end

          def update_where(criterias, values)
            find_all_by(criterias).update(values)
          end

          def delete_where(criterias)
            find_all_by(criterias).delete
          end
        end
      end
    end
  end
end
