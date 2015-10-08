module Koine
  module Repository
    module Persistence
      class Adapter
        class Sql < Adapter
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
