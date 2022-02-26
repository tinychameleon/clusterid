# frozen_string_literal: true

require "test_helper"

class TestClusterIdV1Clock < Minitest::Test
  def setup
    @clock = ClusterId::V1::Clock
  end

  def test_clock_returns_realtime_process_milliseconds
    gettime = ->(clock_id, unit) {
      return 1234 if clock_id == Process::CLOCK_REALTIME && unit == :millisecond
    }
    Process.stub :clock_gettime, gettime do
      assert_equal 1234, @clock.now_ms
    end
  end
end
