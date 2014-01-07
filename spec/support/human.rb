module HumanMacros
  def redefine_human_class
    before :each do
      Object.__send__ :remove_const, "Human" if Object.const_defined? "Human"
      Object.const_set("Human", Class.new do
        include TakeCare::Reliable
        def id
          4
        end

        def hard_work(box1, box2)
        end

        private
        def take_care_hard_work_in_guts(box1, box2)
        end

        class << self
          def do_stuff(garbage1, garbage2)
          end

          private
          def take_care_do_stuff_in_guts(garbage1, garbage2)
          end
        end
      end)
    end
  end
end

RSpec.configure do |config|
  config.extend HumanMacros
end
