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

  # An error representing an invalid data format version for a value.
  class InvalidVersionError < Error
    # @param expected [Integer] the expected data format version
    # @param received [Integer] the received data format version
    def initialize(expected, received)
      super("Expected version #{expected}, got #{received}")
    end
  end
end
