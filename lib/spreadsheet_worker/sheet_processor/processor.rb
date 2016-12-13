module SpreadsheetWorker
  module SheetProcessor
    class Processor

      def process_spreadsheet(agency_template_id)
        process_registrations(agency_template_id)
        process_subsidiaries(agency_template_id)
        process_licencees(agency_template_id)
        process_joiners(agency_template_id)
        process_leavers(agency_template_id)
        process_subleavers(agency_template_id)
        process_targets(agency_template_id)
      end

      private

      def process_registrations
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
