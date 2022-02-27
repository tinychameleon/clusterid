# frozen_string_literal: true

module V1DeserializerInterfaceTests
  def test_deserializer_responds_to_method_to_environment
    assert_respond_to @deserializer, :to_environment
  end

  def test_deserializer_responds_to_method_to_data_centre
    assert_respond_to @deserializer, :to_data_centre
  end

  def test_deserializer_responds_to_method_to_type_id
    assert_respond_to @deserializer, :to_type_id
  end
end
