module TakeCare
  module Reliable
    module RespondTo
      def respond_to?(method_name, include_private = false)
        return include_private if self.private_methods.include?(method_name)
        /\Atake_care_(?:of_)?(.+)\Z/ =~ method_name && self.respond_to?($1) || super
      end
    end
  end
end
