class ReportsController < ApplicationController
  authorize_resource class: ReportsController

  YEARS =  %w(2013 2014 2015 2016).freeze
  REPORTS = ['Registration Form', 'Data Form'].freeze

  def index
    @reports = REPORTS
    @years = YEARS

    @report_form_data = if can_process_report?(params['year'], params['report'])
                          scheme_id = params[:scheme_id]
                          businesses = Scheme.find(scheme_id).businesses
                          get_report_data(businesses, params['report'].first.demodulize.underscore.freeze, params['year'])
                        else
                          []
                        end
  end

  def create
    report_type = params['report'].delete(' ')
    year = params['year']

    report = case report_type
               when 'RegistrationForm'
                 Reporting::Reports::RegistrationForm.new
             end

    num_reports = 0
    params['businesses'].each do |business_id, values|
      if values['email'] == '1'
        report.process_report(business_id.to_i, year, current_user)
        num_reports += 1
      end
    end
    plural = num_reports > 1 ? 's' : ''

    flash[:notice] = "#{num_reports} #{params['report']}#{plural} successfully emailed"
    redirect_to :root
  end

  private

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
      r.date_last_sent = report_last_sent(business, report_name, year)
      report_form_data << r
    end
    report_form_data
  end

  def report_last_sent(business, report_name, year)
    emailed_report = EmailedReport.where(business_id: business.id, report_name: report_name, year: year)
    emailed_report.first.date_last_sent if emailed_report.any?
  end
end
