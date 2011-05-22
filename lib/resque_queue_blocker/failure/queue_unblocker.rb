module Resque
  module Failure
    # A Failure backend that sends exceptions raised by jobs to Hoptoad.
    #
		# You must you this backend to avoid permenantly locking up the queue.
    # To use it, put this code in an initializer, Rake task, or wherever:
    #
    #   Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::QueueUnblocker]
    #   Resque::Failure.backend = Resque::Failure::Multiple
    #
    class QueueUnblocker < Base

      def self.count
        # We can't get the total # of errors so we fake it
        # by asking Resque how many errors it has seen.
        Stat[:failed]
      end

      def save
        HoptoadNotifier.notify_or_ignore(exception,
          :parameters => {
            :payload_class => payload['class'].to_s,
            :payload_args => payload['args'].inspect
          }
        )
      end

    end
  end
end