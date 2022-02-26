# frozen_string_literal: true

module ClusterId
  module V1
    # A millisecond clock which extracts time information from the +Process+
    # module.
    class Clock
      # @return [Integer] A millisecond timestamp since the Unix epoch
      def self.now_ms
        Process.clock_gettime Process::CLOCK_REALTIME, :millisecond
      end
    end
  end
end
