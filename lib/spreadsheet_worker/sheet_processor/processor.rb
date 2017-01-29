module SpreadsheetWorker
  module SheetProcessor
    class Processor
      include Logging
      include SheetHandlers

      def initialize(template_id)
        @agency_template_id = template_id
        @template_upload = AgencyTemplateUpload.find_by_id(template_id)
      end

      def process_spreadsheet
        logger.tagged("Processor::process_spreadsheet() with template_id #{@agency_template_id}") do
          logger.info 'beginning transaction'

          ActiveRecord::Base.transaction do
            logger.info 'beginning process_registrations'
            process_registrations
            logger.info 'beginning process_subsidiaries'
            process_subsidiaries
            logger.info 'beginning process_licensors'
            process_licensors
            logger.info 'beginning process_joiners'
            process_joiners
            logger.info 'beginning process_leavers'
            process_leavers
            logger.info 'beginning process_subleavers'
            process_subleavers
            logger.info 'beginning process_targets'
            process_targets
            logger.info 'deleting temp file from server'

            InputOutput::ServerFileHandler.delete_file_from_server(@template_upload.filename)
            logger.info 'Setting AgencyTemplateUpload status to success'
            @template_upload.status = 'Processed Successfully'
            @template_upload.save
          end
        end
      rescue => e
        logger.info 'Setting AgencyTemplateUpload status to FAILED'
        @template_upload.status = 'FAILED'
        @template_upload.save
        logger.error "AgencyTemplate processing failed for #{@agency_template_id} with ERROR: #{e.message}"
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
