# frozen_string_literal: true

require "test_helper"
require_relative "deserializer_interface_tests"

class TestV1NullDeserializer < Minitest::Test
  include V1DeserializerInterfaceTests

  def setup
    @deserializer = ClusterId::V1::NullDeserializer.new
  end

  def test_to_environment_always_returns_nil
    (0..3).each do |n|
      assert_nil @deserializer.to_environment n
    end
  end

  def test_to_data_centre_always_returns_nil
    (0..7).each do |n|
      assert_nil @deserializer.to_data_centre n
    end
  end

  def test_to_type_id_always_returns_nil
    (0..2**16-1).each do |n|
      assert_nil @deserializer.to_type_id n
    end
  end
end
