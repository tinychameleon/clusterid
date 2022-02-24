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
      # @return [String] the underlying value bytes
      attr_reader :bytes

      # @return [DateTime] the value's creation datetime
      def datetime
        return @dt unless @dt.nil?
        @dt = DateTime.strptime(bytes[8..].unpack('Q')[0].to_s, "%Q")
      end

      # @return [Integer] the value's random nonce
      def nonce
        return @nonce unless @nonce.nil?
        @nonce = (bytes[..4] + "\x00\x00\x00").unpack('Q')[0]
      end

      # @return [Integer] the value's version
      def version
        1
      end

      # @return [T] the value's deserialized environment
      def environment
        return @env unless @env.nil?
        @env = @deserializer.to_environment bytes[7].unpack('C')[0] & 0x03
      end

      # @return [T] the value's deserialized data centre
      def data_centre
        return @dc unless @dc.nil?
        @dc = @deserializer.to_data_centre (bytes[7].unpack('C')[0] & 0x1c) >> 2
      end

      # @return [T] the value's deserialized type ID
      def type_id
        return @tid unless @tid.nil?
        @tid = @deserializer.to_type_id bytes[5..6].unpack('S')[0]
      end

      # @param bytes [String] the value as a byte string?
      # @param deserializer [Deserializer] a {Deserializer} to decode value attributes
      # @raise [InvalidByteLengthError] when the length of bytes is not {BYTE_SIZE}
      def initialize(bytes, deserializer)
        raise InvalidByteLengthError, bytes.length unless bytes.length == BYTE_SIZE
        @bytes = bytes
        @deserializer = deserializer
      end
    end
  end
end
