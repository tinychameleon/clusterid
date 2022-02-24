# frozen_string_literal: true

module ClusterId
  # The base error for all errors in {ClusterId}.
  class Error < StandardError; end

  # An error representing an invalid byte length for a value.
  class InvalidByteLengthError < Error
    # @param length [Integer] the byte length considered invalid
    def initialize(length)
      super("Expected #{BYTE_SIZE} bytes, got #{length}")
    end
  end
end
