# frozen_string_literal: true

module V1SerializerInterfaceTests
  def test_serializer_responds_to_method_to_environment
    assert_respond_to @serializer, :from_environment
  end

  def test_serializer_responds_to_method_to_data_centre
    assert_respond_to @serializer, :from_data_centre
  end

  def test_serializer_responds_to_method_to_type_id
    assert_respond_to @serializer, :from_type_id
  end
end
