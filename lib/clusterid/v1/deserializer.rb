# frozen_string_literal: true

module ClusterId::V1
  # The abstract base class of all custom deserializtion logic.
  class Deserializer
    # @param i [Integer] the serialized environment
    # @return [T] the deserialized environment
    def to_environment(i)
      raise NotImplementedError
    end

    # @param i [Integer] the serialized data centre
    # @return [T] the deserialized data centre
    def to_data_centre(i)
      raise NotImplementedError
    end

    # @param i [Integer] the serialized type ID
    # @return [T] the deserialized type ID
    def to_type_id(i)
      raise NotImplementedError
    end
  end
end
