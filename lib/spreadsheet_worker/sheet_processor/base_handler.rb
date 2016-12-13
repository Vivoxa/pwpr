require 'roo-xls'
require_relative '../sheet_map_loader/map'

module SpreadsheetWorker
  module SheetProcessor
    class BaseHandler
      include SheetMapLoader

      protected

      def get_business(row)
        npwd = column_value(row, map['npwd']['field'])
        business = Business.where(NPWD: npwd).first if npwd

        business ||= create_business(row, npwd)
        business
      end

      def get_agency_template
        AgencyTemplateUpload.where(filename: @sheet_filename).first
      end

      def map
        map_loader.load(:registrations)
      end

      def map_loader
        @map ||= SpreadsheetWorker::SheetMapLoader::Map.new
      end

      def spreadsheet
        @sheet ||= Roo::Spreadsheet.open(@sheet_filename)
      end

      def column_value(row, letter)
        index = transform_to_index(letter)
        value = row[index]

        return boolean_column_value(value) if %w(Y N).include? value
        value
      end

      def boolean_column_value(value)
        value == 'Y' ? true : false
      end

      def transform_to_index(letter)
        set = ('A'..'EZ').to_a
        set.find_index(letter) if set.include? letter
      end
    end
  end
end
