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
        handler = RegistrationsHandler.new(@agency_template_id)
        handler.process
      end

      def process_subsidiaries
        handler = SubsidiariesHandler.new(@agency_template_id)
        handler.process
      end

      def process_leavers
        handler = LeaversHandler.new(@agency_template_id)
        handler.process
      end

      def process_subleavers
        handler = SubleaversHandler.new(@agency_template_id)
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
