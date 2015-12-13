require "ruby_result/version"

module RubyResult
  class AbstractResult
    def self.===(other)
      other.instance_of?(self)
    end

    attr_reader :value

    def initialize(value)
      @value = value
    end
  end

  class Failure < AbstractResult
    def failure?
      true
    end

    def success?
      false
    end
  end

  class Success < AbstractResult
    def failure?
      false
    end

    def success?
      true
    end
  end

  def Success(v)
    Success.new(v)
  end

  def Failure(v)
    Failure.new(v)
  end
end