# frozen_string_literal: true

require "date"

module ClusterId
  # Data format version 1 for {ClusterId} identifiers. This format supports
  # custom value serialization for data centre, environment, and type IDs.
  #
  # @see Value
  # @see Generator
  module V1
    # The data format version
    FORMAT_VERSION = 1

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
    # Instances of {Value} are +Comparable+ based on the timestamp.
    #
    # === Random Nonce
    # A 5 byte random nonce supports generating approximately 150,000 values before
    # reaching a 1% chance of collision. This applies to each millisecond.
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
    # With the +details+ byte encoding the following data:
    #  o---------------------------------------------------------------o
    #  | bit 8 | bit 7 | bit 6 | bit 5 | bit 4 | bit 3 | bit 2 | bit 1 |
    #  |---------------------------------------------------------------|
    #  |        version        |      data centre      |  environment  |
    #  o---------------------------------------------------------------o
    class Value
      include Comparable

      # @return [String] the underlying value bytes
      attr_reader :bytes

      # [RUBY 2.6][RUBY 2.7]
      # Referencing undefined instance variables causes warnings to be emitted,
      # so +instance_variable_defined?+ is used to determine memoization status.

      # @return [DateTime] the value's creation datetime
      def datetime
        return @dt if instance_variable_defined? :@dt
        @dt = DateTime.strptime(bytes[8..].unpack1("Q").to_s, "%Q")
      end

      # @return [Integer] the value's random nonce
      def nonce
        return @nonce if instance_variable_defined? :@nonce
        @nonce = (bytes[0..4] + "\x00\x00\x00").unpack1("Q")
      end

      # @return [Integer] the value's version
      def version
        FORMAT_VERSION
      end

      # @return [T] the value's deserialized environment
      def environment
        return @env if instance_variable_defined? :@env
        @env = @deserializer.to_environment bytes[7].unpack1("C") & 0x03
      end

      # @return [T] the value's deserialized data centre
      def data_centre
        return @dc if instance_variable_defined? :@dc
        @dc = @deserializer.to_data_centre (bytes[7].unpack1("C") & 0x1c) >> 2
      end

      # @return [T] the value's deserialized type ID
      def type_id
        return @tid if instance_variable_defined? :@tid
        @tid = @deserializer.to_type_id bytes[5..6].unpack1("S")
      end

      # @param bytes [String] the value as a byte string
      # @param deserializer [Deserializer] a {Deserializer} to decode custom value attributes
      # @raise [InvalidByteLengthError] when the length of bytes is not {BYTE_SIZE}
      # @raise [InvalidVersionError] when the data format version is not {FORMAT_VERSION}
      def initialize(bytes, deserializer)
        raise InvalidByteLengthError, bytes.length unless bytes.length == BYTE_SIZE

        version = (bytes[7].unpack1("C") & 0xe0) >> 5
        raise InvalidVersionError.new(FORMAT_VERSION, version) unless version == FORMAT_VERSION

        @bytes = bytes
        @deserializer = deserializer
      end

      # Compares {Value} objects using {#datetime}
      #
      # @param other [Value] the object to compare against
      # @return [-1, 0, 1] -1 when less than +other+, 0 when equal to +other+, 1 when greater than +other+
      def <=>(other)
        datetime <=> other.datetime
      end
    end
  end
end
