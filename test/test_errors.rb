# frozen_string_literal: true

require "test_helper"

class TestErrors < Minitest::Test
  def test_invalid_byte_length_error
    err = ClusterId::InvalidByteLengthError.new(99)
    assert_kind_of ClusterId::Error, err
    assert_equal "Expected 16 bytes, got 99", err.message
  end

  def test_invalid_version_error
    err = ClusterId::InvalidVersionError.new(1, 3)
    assert_kind_of ClusterId::Error, err
    assert_equal "Expected version 1, got 3", err.message
  end
end
