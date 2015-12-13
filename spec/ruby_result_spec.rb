require 'spec_helper'

describe RubyResult do
  include RubyResult

  describe RubyResult::Success do
    describe "#success?" do
      it "is true" do
        expect(RubyResult::Success.new("value").success?).to eq(true)
      end
    end

    describe "#failure?" do
      it "is false" do
        expect(RubyResult::Success.new("value").failure?).to eq(false)
      end
    end

    describe "#value" do
      it "is the value that it was initialized with" do
        expect(RubyResult::Success.new("value").value).to eq("value")
      end
    end

    describe ".===" do
      it "is true when the instance is an instance of self" do
        result = RubyResult::Success.new("value")
        expect(RubyResult::Success === result).to eq(true)
      end

      it "is false when the instance is not an instance of self" do
        result = RubyResult::Failure.new("value")
        expect(RubyResult::Success === result).to eq(false)
      end
    end
  end

  describe RubyResult::Failure do
    describe "#success?" do
      it "is false" do
        expect(RubyResult::Failure.new("value").success?).to eq(false)
      end
    end

    describe "#failure?" do
      it "is true" do
        expect(RubyResult::Failure.new("value").failure?).to eq(true)
      end
    end

    describe "#value" do
      it "is the value that it was initialized with" do
        expect(RubyResult::Failure.new("value").value).to eq("value")
      end
    end

    describe ".===" do
      it "is true when the instance is an instance of self" do
        result = RubyResult::Failure.new("value")
        expect(RubyResult::Failure === result).to eq(true)
      end

      it "is false when the instance is not an instance of self" do
        result = RubyResult::Success.new("value")
        expect(RubyResult::Failure === result).to eq(false)
      end
    end
  end

  describe "#Success" do
    it "creates a Success object" do
      expect(Success("value")).to be_instance_of(RubyResult::Success)
    end
  end

  describe "#Failure" do
    it "creates a Failure object" do
      expect(Failure("value")).to be_instance_of(RubyResult::Failure)
    end
  end
end

