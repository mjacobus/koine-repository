module Koine
  module Repository
    module Persistence
      class Adapter
        def exists?(criterias)
          raise "Method not implemented: 'exists?'"
        end

        def find_one_by(conditions)
          raise "Method not implemented: 'find_one_by'"
        end

        def update_where(conditions)
          raise "Method not implemented: 'update_where'"
        end

        def find_all_by(conditions)
          raise "Method not implemented: 'find_all_by'"
        end

        def find(id)
          raise "Method not implemented: 'find'"
        end

        def insert(values)
          raise "Method not implemented: 'insert'"
        end

        def delete_where(conditions)
          raise "Method not implemented: 'delete_where'"
        end
      end
    end
  end
end
