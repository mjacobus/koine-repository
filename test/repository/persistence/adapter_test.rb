require "minitest_helper"

class PersistenceTest < Minitest::Test
  def setup
    @persistence = ::Koine::Repository::Persistence::Adapter.new
  end

  [
    :exists?,
    :find_one_by,
    :update_where,
    :find_all_by,
    :find,
    :insert,
    :delete_where,
  ].each do |method|

    # responds to?
    define_method "test_responds_to#{method}" do
      assert_respond_to(@persistence, method)
    end

    # throws exception when calling method
    define_method "test_throws_exception_method_not_implemented_when_calling_#{method}" do
      begin
        @persistence.send(method, {})
        fail "should have thrown exception"
      rescue RuntimeError => e
        assert_equal("Method not implemented: '#{method}'", e.message)
      end
    end
  end
end
