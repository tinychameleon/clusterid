# frozen_string_literal: true

require "test_helper"
require_relative "deserializer_interface_tests"

class TestV1DeserializerInterface < Minitest::Test
  include V1DeserializerInterfaceTests

  def setup
    @deserializer = ClusterId::V1::Deserializer.new
  end
end
