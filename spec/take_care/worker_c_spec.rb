require "spec_helper"

describe TakeCare::WorkerC do
  redefine_human_class

  describe '#perform' do
    it "should include Sidekiq::Worker" do
      expect(described_class.ancestors).to include Sidekiq::Worker
    end

    it "calls class method with received args" do
      expect(Human).to receive(:do_stuff).with(:s1, :s2)
      subject.perform("Human", :do_stuff, :s1, :s2)
    end
  end
end
