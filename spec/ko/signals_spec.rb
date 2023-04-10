# frozen_string_literal: true

RSpec.describe KO::Signals do
  let!(:parent) { KO::Application.new }
  let(:klass) do
    Class.new(KO::Object) do
      signal :something_changed, String, String

      def emit_signal(*args) = emit(:something_changed, *args)
    end
  end

  let(:object) { klass.new(parent:) }

  let(:receiver) { double(on_something_changed: nil) } # rubocop:disable RSpec/VerifiedDoubles

  describe "emitting signals" do
    subject { object.emit_signal(*args) }

    context "when arguments are valid" do
      let(:args) { ["blah", "blah"] }

      it "notifies subscribers" do
        object.something_changed.connect(receiver)
        subject
        expect(receiver).to have_received(:on_something_changed)
      end
    end

    context "when a subclass is used as an argument" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:my_string) { Class.new(String) }
      let(:args) { ["blah", my_string.new("123")] }

      it "notifies subscribers" do
        object.something_changed.connect(receiver)
        subject
        expect(receiver).to have_received(:on_something_changed)
      end
    end

    context "when arguments have invalid types" do
      let(:args) { ["blah", 123] }

      it "raises an exception" do
        expect do
          subject
        end.to raise_error(KO::EmitError, "expected args: [String, String]. given: [String, Integer]")
      end
    end

    context "when there are too few arguments" do
      let(:args) { ["blah"] }

      it "raises an exception" do
        expect do
          subject
        end.to raise_error(KO::EmitError, "expected args: [String, String]. given: [String]")
      end
    end

    context "when there are too many arguments" do
      let(:args) { ["blah", "blah", "blah"] }

      it "raises an exception" do
        expect do
          subject
        end.to raise_error(KO::EmitError, "expected args: [String, String]. given: [String, String, String]")
      end
    end
  end
end
