# frozen_string_literal: true

RSpec.describe KO::Signals::Signal do
  let(:signal) { described_class.new(:something_changed, [String, String]) }

  let(:receiver) { instance_double(Proc, call: true) }

  describe "#connect" do
    subject { signal.connect(receiver) }

    context "when connected to an object" do
      it "connects" do
        expect { subject }.to change { signal.connections.count }.from(0).to(1)
      end

      it "returns a Connection" do
        expect(subject).to be_an_instance_of(KO::Signals::Connection)
      end
    end

    context "when connected to a method" do
      let(:receiver) { super().method(:call) }

      it "connects" do
        expect { subject }.to change { signal.connections.count }.from(0).to(1)
      end

      it "returns a Connection" do
        expect(subject).to be_an_instance_of(KO::Signals::Connection)
      end
    end

    context "when connecting to another signal" do
      context "when signal's arity fits" do
        let(:receiver) { described_class.new(:another_signal, [String, String]) }

        it "connects" do
          expect { subject }.to change { signal.connections.count }.from(0).to(1)
        end

        it "returns a Connection" do
          expect(subject).to be_an_instance_of(KO::Signals::Connection)
        end
      end
    end

    context "when connecting to a non-receiver" do
      let(:receiver) { "foo" }

      it "raises an exception" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#disconnect" do
    subject { signal.disconnect(receiver) }

    context "when argument is an object" do
      before { signal.connect(receiver) }

      it "unsubscribes" do
        expect { subject }.to change { signal.connections.count }.from(1).to(0)
      end
    end

    context "when argument is a signal" do
      let(:receiver) { described_class.new(:another_signal, [String, String]) }

      before { signal.connect(receiver) }

      it "unsubscribes" do
        expect { subject }.to change { signal.connections.count }.from(1).to(0)
      end
    end

    context "when argument is invalid" do
      let(:receiver) { "blah" }

      it "raises an exception" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "when argument was not subscribed" do
      it "raises an exception" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#call" do
    subject { signal.call("blah", "blah") }

    context "when has one shot connection" do
      it "notifies receiver" do
        signal.connect(receiver, one_shot: true)
        subject
        expect(receiver).to have_received(:call)
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
        expect(receiver).to have_received(:call)
      end
    end

    context "when connected to a signal" do
      let(:another_signal) { described_class.new(:another_signal, [String, String]) }

      it "notifies receiver" do
        signal.connect(another_signal)
        another_signal.connect(receiver)
        subject
        expect(receiver).to have_received(:call).with("blah", "blah")
      end
    end
  end
end
