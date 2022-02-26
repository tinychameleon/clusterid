# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

require "benchmark/ips"
require "date"
require "securerandom"
require "clusterid"

class Serializer < ClusterId::V1::Serializer
  def from_data_centre(s)
    case s
    when :north_america then 4
    end
  end

  def from_environment(s)
    case s
    when :testing then 1
    end
  end

  def from_type_id(s)
    case s
    when :test_data then 99
    end
  end
end

class Deserializer < ClusterId::V1::Deserializer
  def to_data_centre(i)
    case i
    when 1 then :north_america
    end
  end

  def to_environment(i)
    case i
    when 1 then :testing
    end
  end

  def to_type_id(i)
    case i
    when 99 then :test_data
    end
  end
end

DATA = "\x01\x02\x03\x04\x05\x06\x07\x29\x6d\xE5\x62\x29\x7F\x01\x00\x00"

Benchmark.ips do |b|
  deserializer = Deserializer.new
  generator = ClusterId::V1::Generator.new(Serializer.new, deserializer)

  b.report("generate") do |n|
    n.times do
      generator.generate(
        data_centre: :north_america, environment: :testing, type_id: :test_data
      )
    end
  end

  b.report("value") do |n|
    n.times { ClusterId::V1::Value.new(DATA, deserializer) }
  end
end
