require "spec_helper"

describe TakeCare::Reliable do
  redefine_human_class
  context "Instance methods" do
    subject { Human.new }

    describe "#take_care" do
      it "delegates method calls to Worker" do
        expect(TakeCare::Worker).to receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2)
        subject.take_care :hard_work, :box1, :box2
      end
    end

    describe "#take_care_of (alias of #take_care)" do
      it "delegates method calls to Worker" do
        expect(TakeCare::Worker).to receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2)
        subject.take_care_of :hard_work, :box1, :box2
      end
    end

    context 'Dynamic methods "take_care_..."' do
      describe "#method_missing" do
        it "delegates method calls to Worker" do
          expect(TakeCare::Worker).to receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2)
          subject.take_care_hard_work :box1, :box2
        end

        it "defines dynamic method after first call (method missing should not be called after that)" do
          allow(TakeCare::Worker).to receive(:perform_async)
          subject.take_care_hard_work :box1, :box2
          expect(Human.instance_methods(false)).to be_include :take_care_hard_work
        end

        it "second time acts same as first (dynamically defined method)" do
          expect(TakeCare::Worker).to receive(:perform_async).with("Human", 4, :hard_work, :box1, :box2).twice
          subject.take_care_hard_work :box1, :box2
          subject.take_care_hard_work :box1, :box2
        end

        it "raises error if exists private method with same name" do
          expect { subject.take_care_hard_work_in_guts :box1, :box2 }.to raise_error NameError
        end
      end

      describe "#respond_to?" do
        it { is_expected.to be_respond_to :take_care_hard_work }
        it { is_expected.to be_respond_to :take_care_of_hard_work }

        it "is false if exists private method with such name" do
          is_expected.not_to be_respond_to :take_care_hard_work_in_guts
        end

        it "is true if exists private method with such name and we are checking for private methods as well" do
          is_expected.to be_respond_to(:take_care_hard_work_in_guts, true)
        end
      end
    end
  end

  context "Class methods" do
    subject { Human }

    describe "#take_care" do
      it "delegates class method calls to WorkerC" do
        expect(TakeCare::WorkerC).to receive(:perform_async).with("Human", :do_stuff, :s1, :s2)
        subject.take_care :do_stuff, :s1, :s2
      end
    end

    describe "#take_care_of (alias of #take_care)" do
      it "delegates class method calls to WorkerC" do
        expect(TakeCare::WorkerC).to receive(:perform_async).with("Human", :do_stuff, :s1, :s2)
        subject.take_care_of :do_stuff, :s1, :s2
      end
    end

    context 'Dynamic methods "take_care_..."' do
      describe "#method_missing" do
        it "delegates method calls to WorkerC" do
          expect(TakeCare::WorkerC).to receive(:perform_async).with("Human", :do_stuff, :s1, :s2)
          subject.take_care_do_stuff :s1, :s2
        end

        it "defines dynamic method after first call (method missing should not be called after that)" do
          allow(TakeCare::WorkerC).to receive(:perform_async)
          subject.take_care_do_stuff :s1, :s2
          expect(subject.methods(false)).to be_include :take_care_do_stuff
        end

        it "second time acts same as first (dynamically defined method)" do
          expect(TakeCare::WorkerC).to receive(:perform_async).with("Human", :do_stuff, :s1, :s2).twice
          subject.take_care_do_stuff :s1, :s2
          subject.take_care_do_stuff :s1, :s2
        end

        it "raises error if exists private method with same name" do
          expect { subject.take_care_do_stuff_in_guts :s1, :s2 }.to raise_error NameError
        end
      end

      describe "#respond_to?" do
        it { is_expected.to be_respond_to :take_care_do_stuff }
        it { is_expected.to be_respond_to :take_care_of_do_stuff }

        it "is false if exists private method with such name" do
          is_expected.not_to be_respond_to :take_care_do_stuff_in_guts
        end

        it "is true if exists private method with such name and we are checking for private methods as well" do
          is_expected.to be_respond_to :take_care_do_stuff_in_guts, true
        end
      end
    end
  end
end
