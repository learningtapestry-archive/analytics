module Analytics
  module Janitors
    #
    # Common methods used by importing janitors
    #
    module Importer
      attr_reader :logger, :batch_size

      def initialize(logger, batch_size)
        @logger = logger
        @batch_size = batch_size
      end

      def partial_report(record)
        process_one(record)

        log("Successfully processed #{record}")
        true
      rescue => e
        log("Error processing #{record}")
        false
      end

      def final_report(total, errors)
        log("#{total} processed / #{errors} failures")
      end

      def log(msg)
        logger.debug("[#{self.class.name}] #{msg}")
      end
    end
  end
end
