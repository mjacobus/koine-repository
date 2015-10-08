module Koine
  module Repository
    module Persistence
      module Adapter
        class Sql < Persistence
          attr_reader :adapter, :table

          def initialize(adapter, table)
            @adapter = adapter
            @table = table
          end

          def exists?(conditions)
            adapter[table].where(conditions).limit(2).count > 0
          end
        end
      end
    end
  end
end
