module Reporting
  class Worker < QueueHelpers::RabbitMq::Worker
    def process(event)
      event_data = ReportEventDatum.find(event)

      report_instance = report(event_data)

      event_data.retrieve_business_ids.each do |business_id|
        report_instance.process_report(business_id, event_data.year, current_user(event_data))

        businesses = Business.where(id: business_ids)

        logger.info('Emailing report to SchemeOperator')
        email_scheme_operator(businesses, businesses.first.scheme, event_data.year, current_user(event_data))
      end
      @queue_manager.log(:info, " [x] Event '#{event}' has been processed!")
    end

    def current_user(event)
      case event.current_user_type
      when 'SchemeOperator'
        SchemeOperator.find(event.current_user_id)
      when 'Admin'
        Admin.find(event.current_user_id)
      when 'CompanyOperator'
      end
    end

    def report(event)
      case event.report_type
      when 'Reporting::Reports::RegistrationForm'
        Reporting::Reports::RegistrationForm.new
      end
    end
  end
end
