module SpreadsheetWorker
  module SheetProcessor
    class Processor
      def initialize(template_id)
        @agency_template_id = template_id
      end

      def process_spreadsheet
        process_registrations
        process_subsidiaries
        process_licencees
        process_joiners
        process_leavers
        process_subleavers
        process_targets
      end

      private

      def process_registrations
        handler = SheetHandler::RegistrationsHandler.new(@agency_template_id)
        handler.process
      end

      def process_subsidiaries
        handler = SheetHandler::SubsidiariesHandler.new(@agency_template_id)
        handler.process
      end

      def process_leavers
        handler = SheetHandler::LeaversHandler.new(@agency_template_id)
        handler.process
      end

      def process_subleavers
        handler = SheetHandler::SubleaversHandler.new(@agency_template_id)
        handler.process
      end

      def process_joiners
        handler = SheetHandler::JoinersHandler.new
        handler.process
      end

      def process_licencees
        handler = SheetHandler::LicenceesHandler.new
        handler.process
      end

      def process_targets
        handler = SheetHandler::TargetsHandler.new
        handler.process
      end
    end
  end
end
