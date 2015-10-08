require 'minitest_helper'

module Koine
  class RepositoryTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Koine::Repository::VERSION
    end
  end
end
