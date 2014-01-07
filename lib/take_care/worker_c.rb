require "sidekiq"
require "active_support"

module TakeCare
  class WorkerC
    include ::Sidekiq::Worker

    def perform(class_name, class_method, *args)
      class_name.constantize.__send__(class_method, *args)
    end
  end
end
