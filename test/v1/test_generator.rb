# frozen_string_literal: true

require "test_helper"

class TestClusterIdV1Generator < Minitest::Test
  class FakeByteGenerator
    BYTES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].cycle

    def bytes(n)
      BYTES.take(n).pack("C*")
    end
  end

  class FakeClock
    START = 1645756355666

    def now_ms
      @counter += 1
      FakeClock::START + @counter
    end

    def initialize
      @counter = -1
    end
  end

  class FakeDeserializer < ClusterId::V1::Deserializer
    def to_data_centre(i)
      "data_centre_#{i}"
    end

    def to_environment(i)
      "environment_#{i}"
    end

    def to_type_id(i)
      "type_id_#{i}"
    end
  end

  class FakeSerializer < ClusterId::V1::Serializer
    def from_data_centre(s)
      s.gsub("data_centre_", "").to_i
    end

    def from_environment(s)
      s.gsub("environment_", "").to_i
    end

    def from_type_id(s)
      s.gsub("type_id_", "").to_i
    end
  end

  def setup
    @generator = ClusterId::V1::Generator.new(
      FakeSerializer.new, FakeDeserializer.new, FakeByteGenerator.new, FakeClock.new
    )
  end

  def test_generate_creates_value_with_expected_properties
    v = @generator.generate(data_centre: "data_centre_3", environment: "environment_2", type_id: "type_id_1234")

    assert_equal "2022-02-25T02:32:35+00:00", v.datetime.to_s
    assert_equal 21542142465, v.nonce
    assert_equal 1, v.version
    assert_equal "data_centre_3", v.data_centre
    assert_equal "environment_2", v.environment
    assert_equal "type_id_1234", v.type_id
  end

  def test_generator_can_reconstruct_from_a_byte_string
    a = @generator.generate(data_centre: "data_centre_1", environment: "environment_2", type_id: "type_id_3")
    b = @generator.from_byte_string(a.bytes)
    assert_equal a, b
  end
end
