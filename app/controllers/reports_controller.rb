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
      r.emailed_report = emailed_report(business, report_name, year)
      report_form_data << r
    end
    report_form_data
  end

  def emailed_report(business, report_name, year)
    EmailedReport.where(business_id: business.id, report_name: report_name, year: year).first
  end
end
