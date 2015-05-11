require 'active_support/inflector/methods'
require 'csv'
require 'lt/core'

module Analytics
  module Utils
    module CsvErrors
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      def requires_file!(file_name)
        unless File.exist?(file_name)
          raise LT::FileNotFound, "File not found #{file_name} not found"
        end
      end

      def requires_model!(model_name)
        unless ActiveRecord::Base.descendants.map(&:name).include?(model_name)
          raise LT::ModelNotFound.new(model_name)
        end
      end

      def check_file_format!(attributes, model)
        unless attributes.all? { |k| model.new.has_attribute?(k) }
          raise LT::InvalidFileFormat, "Header does not match a model #{model}"
        end
      end

      module ClassMethods
        def requires_directory!(dir)
          unless File.directory?(dir)
            raise LT::PathNotFound, "Directory not found: #{dir}"
          end
        end
      end
    end

    #
    # REVIEW: This "importer" has similarities with the Janitor base classes.
    # Consider further refactoring.
    #
    class CsvDatabaseLoader
      include CsvErrors

      attr_accessor :filename

      def initialize(filename)
        @filename = filename
      end

      def load
        requires_file!(filename)
        requires_model!(model_name)
        check_file_format!(attributes, model)

        CSV.foreach(@filename, headers: true,
                               header_converters: :symbol,
                               converters: :all) do |line|
          model.create!(line.to_h)
        end
      end

      def self.load_directory(path)
        requires_directory!(path)

        success = 0
        failures = 0

        Dir.glob(File.join(path, '*.csv')) do |filename|
          begin
            new(filename).load

            log("successfully imported #{filename}")
            success += 1
          rescue => e
            log("Error loading #{filename}: #{e.message}")
            failures += 1
          end
        end

        log("#{success} successful, #{failures} failed.")
      end

      def self.log(msg)
        LT.env.logger.debug("[#{self.class.name}] #{msg}")
      end

      def attributes
        header.chomp.split(',')
      end

      def model_name
        @model_name  ||= ActiveSupport::Inflector.classify(basename)
      end

      def model
        @model ||= model_name.constantize
      end

      def header
        @header ||= File.open(@filename).gets
      end

      def basename
        @basename ||= File.basename(@filename, '.csv')
      end
    end
  end
end
