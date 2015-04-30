require_relative 'importer'

module Analytics
  module Janitors
    #
    # Common methods used by extracting janitors
    #
    module Extractor
      include Importer

      def extract
        records, errors = unprocessed, 0

        records.each { |record| errors += 1 unless partial_report(record) }

        final_report(records.size, errors)
      end
    end
  end
end
