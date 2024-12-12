
require 'test/unit'

class MyTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def data_provider
    [[true, true]]
  end

  def test_example
    data_provider.each do |value, expected|
        assert(value == expected, 'Assertion was valid')
    end
  end
end