module Koine
  module Repository
    module Persistence
      class Adapter
        def find(*)
          raise "Method not implemented: 'find'"
        end

        def exists?(*)
          raise "Method not implemented: 'exists?'"
        end

        def find_one_by(*)
          raise "Method not implemented: 'find_one_by'"
        end

        def find_all_by(*)
          raise "Method not implemented: 'find_all_by'"
        end

        def insert(*)
          raise "Method not implemented: 'insert'"
        end

        def update_where(*)
          raise "Method not implemented: 'update_where'"
        end

        def delete_where(*)
          raise "Method not implemented: 'delete_where'"
        end
      end
    end
  end
end
