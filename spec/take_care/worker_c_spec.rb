require "spec_helper"

describe TakeCare::WorkerC do
  redefine_human_class

  describe '#perform' do
    it "should include Sidekiq::Worker" do
      described_class.ancestors.should include Sidekiq::Worker
    end

    it "calls class method with received args" do
      Human.should_receive(:do_stuff).with(:s1, :s2)
      subject.perform("Human", :do_stuff, :s1, :s2)
    end
  end
end
