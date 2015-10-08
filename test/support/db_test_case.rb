class DbTestCase < Minitest::Test
  def self.test(argument, &block)
    define_method "test_#{argument.gsub(' ','_')}" do
      TestDb.inside_transaction do
        instance_eval(&block)
      end
    end
  end
end
