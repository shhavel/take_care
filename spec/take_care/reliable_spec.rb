require "spec_helper"

describe TakeCare::Reliable do
  redefine_human_class
  subject { Human.new }

  describe "#take_care" do
    it "delegates method calls to Worker" do
      TakeCare::Worker.should_receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2)
      subject.take_care :hard_work, :box1, :box2
    end
  end

  describe "#take_care_of (alias of #take_care)" do
    it "delegates method calls to Worker" do
      TakeCare::Worker.should_receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2)
      subject.take_care_of :hard_work, :box1, :box2
    end
  end

  context 'Dynamic methods "take_care_..."' do
    describe "#method_missing" do
      it "delegates method calls to Worker" do
        TakeCare::Worker.should_receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2)
        subject.take_care_hard_work :box1, :box2
      end

      it "defines dynamic method after first call (method missing should not be called after that)" do
        TakeCare::Worker.stub(:perform_async)
        subject.take_care_hard_work :box1, :box2
        Human.instance_methods(false).should be_include :take_care_hard_work
      end

      it "second time acts same as first (dynamically defined method)" do
        TakeCare::Worker.should_receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2).twice
        subject.take_care_hard_work :box1, :box2
        subject.take_care_hard_work :box1, :box2
      end

      it "raises error if exists private method with same name" do
        Human.class_eval { private; def take_care_hard_work; end }
        expect { subject.take_care_hard_work :box1, :box2 }.to raise_error NameError
      end
    end

    describe "#respond_to?" do
      it { should be_respond_to :take_care_hard_work }
      it { should be_respond_to :take_care_of_hard_work }

      it "is false if exists private method with such name" do
        Human.class_eval { private; def take_care_hard_work; end }
        should_not be_respond_to :take_care_hard_work
      end

      it "is true if exists private method with such name and we are checking for private methods as well" do
        Human.class_eval { private; def take_care_hard_work; end }
        should be_respond_to :take_care_hard_work, true
      end
    end
  end
end
