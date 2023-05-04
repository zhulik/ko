# frozen_string_literal: true

RSpec.describe KO::Signals do
  let(:object) do
    Class.new(KO::Object) do
      signal :something_changed, KO::T::Coercible::String, KO::T::String
    end.new
  end

  let(:receiver) { instance_double(Proc, call: true) }

  describe "emitting signals" do
    subject { object.something_changed.emit(*args) }

    context "when arguments are valid" do
      let(:args) { ["blah", "blah"] }

      it "notifies subscribers" do
        object.something_changed.connect(receiver)
        subject
        expect(receiver).to have_received(:call)
      end
    end

    context "when a subclass is used as an argument" do
      let(:my_string) { Class.new(String) }
      let(:args) { ["blah", my_string.new("123")] }

      it "notifies subscribers" do
        object.something_changed.connect(receiver)
        subject
        expect(receiver).to have_received(:call)
      end
    end

    context "when arguments have invalid types" do
      let(:args) { ["blah", 123] }

      it "raises an exception" do
        expect do
          subject
        end.to raise_error(TypeError)
      end
    end

    context "when there are too few arguments" do
      let(:args) { ["blah"] }

      it "raises an exception" do
        expect do
          subject
        end.to raise_error(TypeError)
      end
    end

    context "when there are too many arguments" do
      let(:args) { ["blah", "blah", "blah"] }

      it "raises an exception" do
        expect do
          subject
        end.to raise_error(TypeError)
      end
    end
  end
end
