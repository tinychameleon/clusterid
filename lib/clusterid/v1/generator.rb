# frozen_string_literal: true

module ClusterId::V1
  class Generator
    def initialize(byte_generator, clock, serializer, deserializer)
      @byte_generator = byte_generator
      @clock = clock
      @serializer = serializer
      @deserializer = deserializer
    end

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
