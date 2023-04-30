# frozen_string_literal: true

RSpec.describe KO::Signals do
  let(:object) do
    Class.new(KO::Object) do
      signal :something_changed, String, String
    end.new
  end

  let(:receiver) { proc {} }

  describe "emitting signals" do
    subject { object.something_changed.emit(*args) }

    context "when arguments are valid" do
      let(:args) { ["blah", "blah"] }

      it "notifies subscribers" do
        expect(receiver).to receive(:call) # rubocop:disable RSpec/MessageSpies
        object.something_changed.connect(receiver)
        subject
      end
    end

    context "when a subclass is used as an argument" do
      let(:my_string) { Class.new(String) }
      let(:args) { ["blah", my_string.new("123")] }

      it "notifies subscribers" do
        expect(receiver).to receive(:call) # rubocop:disable RSpec/MessageSpies
        object.something_changed.connect(receiver)
        subject
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
