module SpreadsheetWorker
  module SheetProcessor
    class Processor

      def initialize(template_id)
        @agency_template_id = template_id
      end

      def process_spreadsheet
        process_registrations
        process_subsidiaries
        process_licensors
        process_joiners
        process_leavers
        process_subleavers
        process_targets
      end

      private

      def process_registrations
        handler = SheetHandlers::RegistrationsHandler.new(@agency_template_id)
        handler.process
      end

      def process_subsidiaries
        handler = SheetHandlers::SubsidiariesHandler.new(@agency_template_id)
        handler.process
      end

      def process_leavers
        handler = SheetHandlers::LeaversHandler.new(@agency_template_id)
        handler.process
      end

      def process_subleavers
        handler = SheetHandlers::SubleaversHandler.new(@agency_template_id)
        handler.process
      end

      def process_joiners
        handler = SheetHandlers::JoinersHandler.new(@agency_template_id)
        handler.process
      end

      def process_licensors
        handler = SheetHandlers::LicensorsHandler.new(@agency_template_id)
        handler.process
      end

      def process_targets
        handler = SheetHandlers::TargetsHandler.new(@agency_template_id)
        handler.process
      end
    end
  end
end
