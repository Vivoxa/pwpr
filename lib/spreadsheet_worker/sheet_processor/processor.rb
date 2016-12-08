require 'roo-xls'
require_relative '../sheet_map_loader/map'

module SpreadsheetWorker
  module SheetProcessor
    class Processor
      include SheetMapLoader

      def initialize
        process_registration
        process_subsidiaries
        process_licencees
        process_joiners
        process_leavers
        process_subleavers
        process_targets
      end

      private

      def process_registration
        handler = RegistrationsHandler.new
        handler.process
      end

      def process_subsidiaries
        handler = SubsidiariesHandler.new
        handler.process
      end

      def process_leavers
        handler = LeaversHandler.new
        handler.process
      end

      def process_subleavers
        handler = SubleaversHandler.new
        handler.process
      end

      def process_joiners
        handler = JoinersHandler.new
        handler.process
      end

      def process_licencees
        handler = LicenceesHandler.new
        handler.process
      end

      def process_targets
        handler = TargetsHandler.new
        handler.process
      end
    end
  end
end
