require 'smarter_csv'

module LT
  module Utilities 
    module CsvDatabaseLoader class << self

      def load_file(filename)
        raise LT::FileNotFound, "File not found: #{filename}" if !File.exist?(filename)
        csv_file = SmarterCSV.process(filename)
        if csv_file.length > 0 then
          table_name = File.basename(filename, ".csv")
          model_name = ActiveSupport::Inflector::classify(table_name)
          begin
            model = eval(model_name).new
          rescue Exception => e
            LT::logger.error("CsvDatabaseLoader: Model not found for #{table_name}, exception: #{e.message}")
            raise LT::ModelNotFound
          end

          # Check to ensure the CSV file matches model, if not, invalid file could be loaded
          all_attributes = true
          csv_file[0].keys.each do |key|
            all_attributes = all_attributes && model.has_attribute?(key)
          end

          if all_attributes then
            # Start a transaction for all inserts

            num_inserts = 0;
            ActiveRecord::Base.transaction do
              csv_file.each do |csv_line|
                model = eval(model_name).new
                csv_line.each do |key, value|
                  model[key] = value
                end # csv_line.each
                model.save
                num_inserts += 1
                LT::logger.debug("CsvDatabaseLoader: Saved record type of #{model_name}, record id: #{model.id}")
              end # csv_file.each
            end # ActiveRecord::Base.transaction
            ActiveRecord::Base.connection.reset_pk_sequence!(table_name) # Reset the sequence to highest after import, necessary for PG
            LT::logger.info("CsvDatabaseLoader: Successfully saved #{num_inserts} of record type of #{model_name}")            
          else # all_attributes
            LT::logger.error("CsvDatabaseLoader: Invalid file format, file: #{filename} does not match model: #{model_name}")
            raise LT::InvalidFileFormat, "Invalid file format, file: #{filename} does not match model: #{model_name}"
          end # all_attributes
        end # if csv_file.length > 0 then
      end # load_file

      def load_directory(path)
        raise LT::PathNotFound, "Path not found: #{path}" if !File.directory?(path)

        success = 0; fail = 0
        Dir.glob(File.join(path, "*.csv")) do |filename|
          begin
            self.load_file(filename)
            LT::logger.debug "CsvDatabaseLoader: successfully imported #{filename}"
            success += 1
          rescue Exception => e
            LT::logger.error "CsvDatabaseLoader: cannot load #{filename}\n  #{e.message}"
            fail += 1
          end #begin
        end # Dir.glob
        LT::logger.info "CsvDatabaseLoader: #{success} successful, #{fail} failed."
      end #load_all
    end ; end # CsvDatabaseUtility and class
  end # LT::Utilities
end # LT
