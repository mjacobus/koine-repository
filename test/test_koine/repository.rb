require 'minitest_helper'

class TestKoine::Repository < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Koine::Repository::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
