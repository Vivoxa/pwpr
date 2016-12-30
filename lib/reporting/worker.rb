module Reporting
  class Worker < QueueHelpers::RabbitMq::Worker
    include Logging

    def process(event)
      logger.tagged('Reporting Worker::process(event)') do
        event_data = ReportEventDatum.find(event)
        report_instance = report(event_data)

        business_ids= []

        logger.info('Iterating over businesses, processing registration forms')
        event_data.retrieve_business_ids.each do |business_id|
          success = report_instance.process_report(business_id, event_data.year, current_user(event_data))
          business_ids << business_id if success
        end

        logger.info("Successfully processed the following businesses: #{business_ids.inspect}")
        @queue_manager.log(:info, " [x] Event '#{event}' has been processed!")

        businesses = Business.where(id: business_ids)

        logger.info('Emailing report to SchemeOperator')
        email_scheme_operator(businesses, businesses.first.scheme, event_data.year, current_user(event_data).email)
      end
    end

    def current_user(event)
      case event.current_user_type
        when 'SchemeOperator'
          SchemeOperator.find(event.current_user_id)
        when 'Admin'
          Admin.find(event.current_user_id)
        when 'CompanyOperator'
          CompanyOperator.find(event.current_user_id)
      end
    end

    def report(event)
      case event.report_type
        when 'Reporting::Reports::RegistrationForm'
          Reporting::Reports::RegistrationForm.new
      end
    end

    def email_scheme_operator(businesses, scheme, year, recipient_email)
      SchemeMailer.scheme_director_info(businesses, scheme, year, recipient_email).deliver_now
    end
  end
end
