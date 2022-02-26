# frozen_string_literal: true

module ClusterId
  module V1
    # Create instances of {Value} objects based on time, random data, and serializable
    # values for data centre, environment, and type IDs.
    class Generator
      # @note It is the caller's responsibility to ensure the serializer and deserializer
      #       follow the expected bit lengths for custom types. No overflow checks are done.
      #       Overflow will either be discarded or overwrite other bits. See the {Value}
      #       class for allowed bit lengths.
      #
      # @param byte_generator [#bytes(n)] an object which provides random bytes
      # @param clock [#now_ms] an object which provides millisecond timestamps
      # @param serializer [Serializer] an object which serializes {Value} attributes
      # @param deserializer [Deserializer] an object which deserializes {Value} attributes
      def initialize(byte_generator, clock, serializer, deserializer)
        @byte_generator = byte_generator
        @clock = clock
        @serializer = serializer
        @deserializer = deserializer
      end

      # Generate a {Value} for a given data centre, environment, and type ID.
      #
      # @param data_centre [D] a serializable value representing the data centre the {Value} is generated within
      # @param environment [E] a serializable value representing the environment the {Value} is generated within
      # @param type_id [T] a serializable value representing the type of entity for a generated {Value}
      # @return [Value] a time-based, partially random value to identify an entity
      def generate(data_centre:, environment:, type_id:)
        raw_data = +""
        # Nonce
        raw_data += @byte_generator.bytes(5)
        # Type ID
        raw_data += [@serializer.from_type_id(type_id)].pack("S")
        # Details (Version, Data Centre, Environment)
        raw_data += [
          (FORMAT_VERSION << 5) +
          (@serializer.from_data_centre(data_centre) << 2) +
          @serializer.from_environment(environment)
        ].pack("C")
        # Timestamp
        raw_data += [@clock.now_ms].pack("Q")

        Value.new(raw_data.freeze, @deserializer)
      end
    end
  end
end
