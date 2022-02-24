# frozen_string_literal: true

require "test_helper"

class TestClusterIdV1Value < Minitest::Test
  # TODO:
  #   - extract attribute tests
  #   - error handling for deserializer failures

  module FakeDeserializer
    def self.to_data_centre(i)
      "data_centre_#{i}"
    end

    def self.to_environment(i)
      "environment_#{i}"
    end

    def self.to_type_id(i)
      "type_id_#{i}"
    end
  end

  # Little-endian order for byte packing.
  DATA = [
    # Random nonce, 5 bytes.
    "\x01\x02\x03\x04\x05",
    # Type ID, 2 bytes.
    "\x06\x07",
    # Version 1 (3 bits), Data Centre 4 (3 bits), Environment 1 (2 bits), 1 byte.
    "\x29",
    # Timestamp (milliseconds), 8 bytes
    "\x6d\xE5\x62\x29\x7F\x01\x00\x00",
  ].join.freeze

  def create_value(data)
    ClusterId::V1::Value.new(data, FakeDeserializer)
  end

  def setup
    @value = create_value DATA
  end

  def test_invalid_byte_length_is_an_error
    assert_raises(ClusterId::InvalidByteLengthError) { create_value "\x01" }
    assert_raises(ClusterId::InvalidByteLengthError) { create_value "\x01" * 20 }
  end

  def test_wrong_version_is_an_error
    bad_data = DATA.dup
    bad_data[7] = "\x49"
    assert_raises(ClusterId::InvalidVersionError) { create_value bad_data }
  end

  def test_datetime_extracts
    assert_instance_of DateTime, @value.datetime
    assert_equal "2022-02-24T01:40:21+00:00", @value.datetime.to_s
  end

  def test_version_is_1
    assert_equal 1, @value.version
  end

  def test_random_nonce_extracts
    assert_instance_of Integer, @value.nonce
    assert_equal 21542142465, @value.nonce
  end

  def test_environment_extracts_through_deserializer
    assert_equal "environment_1", @value.environment
  end

  def test_data_centre_extracts_through_deserializer
    assert_equal "data_centre_2", @value.data_centre
  end

  def test_type_id_extracts_through_deserializer
    assert_equal "type_id_1798", @value.type_id
  end

  def test_bytes_are_accessible
    assert_equal DATA, @value.bytes
  end
end
