class ReportsController < ApplicationController
  authorize_resource class: ReportsController

  YEARS = %w(2013 2014 2015 2016).freeze
  REPORTS = ['Registration Form', 'Data Form'].freeze

  def index
    @reports = REPORTS
    @years = YEARS
    @report_form_data = []
  end

  def report_data
    report = params['report']
    year = params['year']
    scheme_uid = params[:scheme_id]
    @report_form_data = []

    @errors = []

    unless REPORTS.include?(report)
      @errors << 'Select a Report'
    end

    unless YEARS.include?(year)
      @errors << 'Select a Year'
    end

    @report_form_data = if can_process_report?(year, report)
                          scheme_id = scheme_uid
                          businesses = Scheme.find(scheme_id).businesses
                          get_report_data(businesses, report.delete(' ').demodulize.underscore.freeze, year)
                        else
                          []
                        end
  end

  respond_to do |format|
    format.js
  end

  def create
    report_type = params['report'].delete(' ')
    year = params['year']

    report = case report_type
               when 'RegistrationForm'
                 Reporting::Reports::RegistrationForm
             end
    business_ids = []

    num_reports = 0
    params['businesses'].each do |business_id, values|
      if values['email'] == '1'
        business_ids << business_id.to_i
        num_reports += 1
      end
    end

    event_data = ReportEventDatum.create({report_type: report,
                                          year: year,
                                          current_user_id: current_user.id,
                                          current_user_type: current_user.class.name,
                                          business_ids: business_ids.join(',')})

    publish_email_reports(event_data.id.to_s)

    plural = num_reports > 1 ? 's' : ''

    flash[:notice] = "#{num_reports} #{params['report']}#{plural} queued to be emailed"
    redirect_to :root
  end

  private

  def publish_email_reports(event_data)
    publisher = QueueHelpers::RabbitMq::Publisher.new(ENV['REPORTS_QUEUE_NAME'],
                                                      ENV['REPORTS_QUEUE_HOST'],
                                                      ENV['REPORTS_WORKER_LOG_PATH'])
    publisher.publish(event_data)
  end

  def can_process_report?(year, report)
    !year.blank? && YEARS.include?(year) && !report.blank? && REPORTS.include?(report)
  end

  def get_report_data(businesses, report_name, year)
    report_form_data = []
    businesses.each do |business|
      r = ReportFormData.new
      r.business_id = business.id
      r.business_name = business.name
      r.email = false
      r.email_contact_present = business.correspondence_contact.present?
      r.emailed_report = emailed_report(business, report_name, year)
      report_form_data << r
    end
    report_form_data
  end

  def emailed_report(business, report_name, year)
    EmailedReport.where(business_id: business.id, report_name: report_name, year: year).first
  end
end
