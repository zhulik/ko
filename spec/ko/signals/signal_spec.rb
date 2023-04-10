# frozen_string_literal: true

RSpec.describe KO::Signals::Signal do
  let(:signal) { described_class.new(:something_changed, [String, String]) }
  let(:receiver) { double(on_something_changed: nil) } # rubocop:disable RSpec/VerifiedDoubles
  let(:parent) { KO::Application.new }

  describe "#connect" do
    subject { signal.connect(callable) }

    context "when connected to an object" do
      let(:callable) { receiver }

      it "connects" do
        expect { subject }.to change { signal.connections.count }.from(0).to(1)
      end

      it "returns a Connection" do
        expect(subject).to be_an_instance_of(KO::Signals::Connection)
      end
    end

    context "when connected to a method" do
      let(:callable) { receiver.method(:on_something_changed) }

      it "connects" do
        expect { subject }.to change { signal.connections.count }.from(0).to(1)
      end

      it "returns a Connection" do
        expect(subject).to be_an_instance_of(KO::Signals::Connection)
      end
    end

    context "when connecting to another signal" do
      context "when signal's arity fits" do
        let(:callable) { described_class.new(:another_signal, [String, String]) }

        it "connects" do
          expect { subject }.to change { signal.connections.count }.from(0).to(1)
        end

        it "returns a Connection" do
          expect(subject).to be_an_instance_of(KO::Signals::Connection)
        end
      end

      context "when signal's arity does not fit" do
        let(:callable) { described_class.new(:another_signal, [String]) }

        it "raises an exception" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    context "when connecting to a non-callable" do
      let(:callable) { "foo" }

      it "raises an exception" do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe "#disconnect" do
    subject { signal.disconnect(callable) }

    context "when argument is an object" do
      let(:callable) { receiver }

      before { signal.connect(callable) }

      it "unsubscribes" do
        expect { subject }.to change { signal.connections.count }.from(1).to(0)
      end
    end

    context "when argument is a signal" do
      let(:callable) { described_class.new(:another_signal, [String, String]) }

      before { signal.connect(callable) }

      it "unsubscribes" do
        expect { subject }.to change { signal.connections.count }.from(1).to(0)
      end
    end

    context "when argument is invalid" do
      let(:callable) { "blah" }

      it "raises an exception" do
        expect { subject }.to raise_error(ArgumentError, "given callable is not connected to this signal")
      end
    end

    context "when argument was not subscribed" do
      let(:callable) { receiver }

      it "raises an exception" do
        expect { subject }.to raise_error(ArgumentError, "given callable is not connected to this signal")
      end
    end
  end

  describe "#call" do
    subject { signal.call("blah", "blah") }

    context "when has one shot connection" do
      it "notifies receiver" do
        signal.connect(receiver, one_shot: true)
        subject
        expect(receiver).to have_received(:on_something_changed)
      end

      it "removes the connection" do
        expect do
          signal.connect(receiver, one_shot: true)
          subject
        end.not_to(change { signal.connections.count })
      end
    end

    context "when connected to an object" do
      it "notifies receiver" do
        signal.connect(receiver)
        subject
        expect(receiver).to have_received(:on_something_changed)
      end
    end

    context "when connected to a signal" do
      let(:another_signal) { described_class.new(:another_signal, [String, String]) }
      let(:receiver) { double(on_another_signal: nil) } # rubocop:disable RSpec/VerifiedDoubles

      it "notifies receiver" do
        signal.connect(another_signal)
        another_signal.connect(receiver)
        subject
        expect(receiver).to have_received(:on_another_signal).with("blah", "blah")
      end
    end
  end

  describe "#parent=" do
    subject { signal.parent = obj }

    context "when given object is KO::Object" do
      let(:obj) { KO::Object.new(parent:) }

      it "assigns a parent" do
        expect { subject }.to change(signal, :parent).from(nil).to(obj)
      end
    end

    context "when given object is not a KO::Object" do
      let(:obj) { Object.new }

      it "raises" do
        expect { subject }.to raise_error(KO::InvalidParent)
      end
    end

    context "when signal already has parent" do
      let(:obj) { KO::Object.new(parent:) }

      before do
        signal.parent = obj
      end

      it "raises" do
        expect { subject }.to raise_error(KO::SignalParentOverrideError)
      end
    end
  end
end
