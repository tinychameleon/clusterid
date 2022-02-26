# frozen_string_literal: true

module ClusterId
  module V1
    # The abstract base class of all custom serialization logic.
    class Serializer
      # @param t [T] the environment
      # @return [Integer] the serialized environment
      def from_environment(t)
        raise NotImplementedError
      end

      # @param t [T] the data centre
      # @return [Integer] the serialized data centre
      def from_data_centre(t)
        raise NotImplementedError
      end

      # @param t [T] the type ID
      # @return [Integer] the serialized type ID
      def from_type_id(t)
        raise NotImplementedError
      end
    end

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
end
