module Koine
  module Repository
    module Persistence
      class Adapter
        class Sql < Adapter
          attr_reader :adapter, :table_name, :table

          def initialize(adapter, table_name)
            @adapter = adapter
            @table_name = table_name
            @table = adapter[table_name]
          end

          def exists?(criterias)
            table.where(criterias).limit(2).count > 0
          end

          def find_one_by(criterias)
            table.where(criterias).first!
          end

          def find_all_by(criterias)
            table.where(criterias)
          end

          def update_where(criterias, values)
            find_all_by(criterias).update(values)
          end
        end
      end
    end
  end
end
