# frozen_string_literal: true

module ClusterId
  module V1
    # A default {Deserializer} that returns +nil+ for all attributes.
    class NullDeserializer < Deserializer
      # Null method which ignores all data centre values.
      # @return [nil]
      def to_data_centre(_)
        nil
      end

      # Null method which ignores all environment values.
      # @return [nil]
      def to_environment(_)
        nil
      end

      # Null method which ignores all type ID values.
      # @return [nil]
      def to_type_id(_)
        nil
      end
    end

    # A default {Serializer} that returns +0+ for all attributes.
    class NullSerializer < Serializer
      # Zero method which ignores all data centre values.
      # @return [0]
      def from_data_centre(_)
        0
      end

      # Zero method which ignores all environment values.
      # @return [0]
      def from_environment(_)
        0
      end

      # Zero method which ignores all type ID values.
      # @return [0]
      def from_type_id(_)
        0
      end
    end
  end
end
