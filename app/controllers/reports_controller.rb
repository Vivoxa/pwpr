class ReportsController < ApplicationController
  load_and_authorize_resource :scheme
  authorize_resource class: ReportsController, through: :scheme

  YEARS = LookupValues::ValidYears.for('reports')
  REPORTS = LookupValues::Reports::ValidReports.for('scheme')

  def index
    @reports = REPORTS
    @years = YEARS
    @report_form_data = []
    @scheme = Scheme.find(params[:scheme_id].to_i)
  end

  def report_data
    report = params['report']
    year = params['year'].to_i
    scheme_uid = params[:scheme_id].to_i
    data_present = AgencyTemplateUpload.where(scheme_id: scheme_uid, year: year.to_i - 1).any?

    @report_form_data = []

    @errors = []

    @errors << 'Select a Report' unless REPORTS.include?(report)

    @errors << 'Select a Year' unless YEARS.include?(year)

    @errors << 'No data for this year' unless data_present

    build_report_form_data(report, scheme_uid, year, data_present)
    #@stop_spinner = true if @report_form_data.empty?

    respond_to do |format|
      format.js
    end
  end

  def create
    report_type = params['report'].delete(' ')
    year = params['year']

    report = report_type(report_type)

    business_ids = []
    num_reports = 0
    params['businesses'].each do |business_id, values|
      next unless values['email'] == '1'
      business_ids << business_id.to_i
      num_reports += 1
    end

    event_data = ReportEventDatum.create(report_type: report,
                                         year: year,
                                         current_user_id: current_user.id,
                                         current_user_type: current_user.class.name,
                                         business_ids: business_ids.join(','))

    publish_email_reports(event_data.id.to_s)

    plural = num_reports > 1 ? 's' : ''

    flash[:notice] = "#{num_reports} #{params['report']}#{plural} queued to be emailed"
    redirect_to :root
  end

  private

  def report_type(report_type)
    case report_type
      when 'RegistrationForm'
        Reporting::Reports::RegistrationForm
    end
  end

  def build_report_form_data(report, scheme_uid, year, data_present)
    @report_form_data = if can_process_report?(year, report, data_present)
                          scheme_id = scheme_uid
                          businesses = Scheme.find(scheme_id).businesses.for_registration
                          get_report_data(businesses, report.delete(' ').demodulize.underscore.freeze, year)
                        else
                          []
                        end
  end

  def publish_email_reports(event_data)
    publisher = QueueHelpers::RabbitMq::Publisher.new(ENV['REPORTS_QUEUE_NAME'],
                                                      ENV['REPORTS_QUEUE_HOST'],
                                                      ENV['REPORTS_WORKER_LOG_PATH'])
    publisher.publish(event_data)
  end

  def can_process_report?(year, report, data_present)
    data_present && !year.blank? && YEARS.include?(year) && !report.blank? && REPORTS.include?(report)
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
