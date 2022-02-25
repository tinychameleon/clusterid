# frozen_string_literal: true

require "test_helper"

class TestClusterIdV1Generator < Minitest::Test
  class FakeByteGenerator
    BYTES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].cycle

    def bytes(n)
      BYTES.take(n)
    end
  end

  class FakeClock
    START = 1645756355666

    def now_ms
      START + @counter
      @counter += 1
    end

    def initialize
      @counter = 0
    end
  end

  class FakeSerializer < ClusterId::V1::Serializer
    def from_data_centre(s)
      s.gsub!("data_centre_", "").to_i
    end

    def from_environment(s)
      s.gsub!("environment_", "").to_i
    end

    def from_type_id(s)
      s.gsub!("type_id_", "").to_i
    end
  end

  def setup
    @generator = ClusterId::V1::Generator.new(FakeByteGenerator.new, FakeClock.new, FakeSerializer.new)
  end

  def test_exercise_constructor_types
    assert_equal true, true
  end
end
