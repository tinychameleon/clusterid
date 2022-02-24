# frozen_string_literal: true

require "test_helper"

class TestErrors < Minitest::Test
  def test_invalid_byte_length_error
    assert_equal "Expected 16 bytes, got 99", ClusterId::InvalidByteLengthError.new(99).message
  end
end
