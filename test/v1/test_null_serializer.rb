# frozen_string_literal: true

require "test_helper"
require_relative "serializer_interface_tests"

class TestV1NullSerializer < Minitest::Test
  include V1SerializerInterfaceTests

  def setup
    @serializer = ClusterId::V1::NullSerializer.new
  end

  def test_from_environment_always_returns_zero
    [99, :production, "prod"].each do |v|
      assert_equal 0, @serializer.from_environment(v)
    end
  end

  def test_from_data_centre_always_returns_zero
    [:north_america, "europe", 23].each do |v|
      assert_equal 0, @serializer.from_data_centre(v)
    end
  end

  def test_from_type_id_always_returns_zero
    [:user, "apple", 42].each do |v|
      assert_equal 0, @serializer.from_type_id(v)
    end
  end
end

