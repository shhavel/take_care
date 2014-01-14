require "take_care/reliable/respond_to"

module TakeCare
  module Reliable
    extend ActiveSupport::Concern
    include TakeCare::Reliable::RespondTo

    def take_care(method_name, *args)
      TakeCare::Worker.perform_async(self.class.to_s, self.id, method_name, *args)
    end
    alias_method :take_care_of, :take_care

    def method_missing(method_name, *args, &block)
      if self.private_methods.include?(method_name)
        raise NoMethodError, "private method `#{method_name}' called for #{self}"
      end
      return super unless /\Atake_care_(?:of_)?(.+)\Z/ =~ method_name && self.respond_to?($1)
      self.class.__send__(:define_method, method_name) do |*d_args|
        self.take_care($1.to_sym, *d_args)
      end
      self.take_care($1.to_sym, *args)
    end

    module ClassMethods
      include TakeCare::Reliable::RespondTo

      def take_care(method_name, *args)
        TakeCare::WorkerC.perform_async(self.to_s, method_name, *args)
      end
      alias_method :take_care_of, :take_care

      def method_missing(method_name, *args, &block)
        if self.private_methods.include?(method_name)
          raise NoMethodError, "private method `#{method_name}' called for #{self}"
        end
        return super unless /\Atake_care_(?:of_)?(.+)\Z/ =~ method_name && self.respond_to?($1)
        eigenclass = class << self; self; end
        eigenclass.__send__(:define_method, method_name) do |*d_args|
          self.take_care($1.to_sym, *d_args)
        end
        self.take_care($1.to_sym, *args)
      end
    end
  end
end
