# frozen_string_literal: true

require 'date'

module ClusterId
  module V1
    # A {ClusterId} version 1 format value.
    #
    # A {Value} contains the following accessible properties:
    #
    # - a 64-bit millisecond timestamp as a +DateTime+
    # - a 3-bit version number
    # - a 3-bit data centre identifier
    # - a 2-bit environment identifier
    # - a 16-bit type identifier
    # - a 40-bit random nonce
    #
    # It also provides access to the underlying bytes.
    #
    # === Data Layout
    # The byte layout of a version 1 value in little-endian is:
    #  o-------------------------------------------------------------------------------o
    #  | byte 01 | byte 02 | byte 03 | byte 04 | byte 05 | byte 06 | byte 07 | byte 08 |
    #  |-------------------------------------------------------------------------------|
    #  |                   random nonce                  |      type id      | details |
    #  |-------------------------------------------------------------------------------|
    #  | byte 09 | byte 10 | byte 11 | byte 12 | byte 13 | byte 14 | byte 15 | byte 16 |
    #  |-------------------------------------------------------------------------------|
    #  |                                   timestamp                                   |
    #  o-------------------------------------------------------------------------------o
    # With +details+ encoding the following data in little-endian:
    #  o---------------------------------------------------------------o
    #  | bit 1 | bit 2 | bit 3 | bit 4 | bit 5 | bit 6 | bit 7 | bit 8 |
    #  |---------------------------------------------------------------|
    #  |  environment  |      data centre      |        version        |
    #  o---------------------------------------------------------------o
    class Value
      attr_reader :bytes

      def datetime
        return @dt unless @dt.nil?
        @dt = DateTime.strptime(bytes[8..].unpack('Q')[0].to_s, "%Q")
      end

      def version
        1
      end

      def initialize(bytes)
        raise InvalidByteLengthError, bytes.length unless bytes.length == BYTE_SIZE
        @bytes = bytes
      end
    end
  end
end
