# frozen_string_literal: true

module ClusterId::V1
  # The abstract class of all custom deserializtion logic.
  class Deserializer
    def to_environment(i)
      raise NotImplementedError
    end

    def to_data_centre(i)
      raise NotImplementedError
    end

    def to_type_id(i)
      raise NotImplementedError
    end
  end
end
