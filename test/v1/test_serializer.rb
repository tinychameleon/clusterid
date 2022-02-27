# frozen_string_literal: true

require "test_helper"
require_relative "serializer_interface_tests"

class TestV1SerializerInterface < Minitest::Test
  include V1SerializerInterfaceTests

  def setup
    @serializer = ClusterId::V1::Serializer.new
  end
end
