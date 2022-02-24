# frozen_string_literal: true

require "test_helper"

class TestClusterIdV1Value < Minitest::Test
  # TODO:
  #   - initialize a value with some raw data
  #   - extract attribute tests
  #   - error handling for extraction failures
  #   - error handling for deserializer failures

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

  def setup
    @value = ClusterId::V1::Value.new(DATA)
  end

  def test_invalid_byte_length_is_an_error
    assert_raises(ClusterId::InvalidByteLengthError) { ClusterId::V1::Value.new("\x01") }
    assert_raises(ClusterId::InvalidByteLengthError) { ClusterId::V1::Value.new("\x01" * 20) }
  end

  def test_datetime_extracts_correctly
    assert_instance_of DateTime, @value.datetime
    assert_equal "2022-02-24T01:40:21+00:00", @value.datetime.to_s
  end

  def test_version_is_1
    assert_equal 1, @value.version
  end

  def test_bytes_are_accessible
    assert_equal DATA, @value.bytes
  end
end
