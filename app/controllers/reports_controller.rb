class ReportsController < ApplicationController
  authorize_resource class: ReportsController

  def index
    scheme_id = params[:scheme_id]
    businesses = Scheme.find(scheme_id).businesses
    @reports = ['Registration Form', 'Data Form']
    @years = %w(2013 2014 2015 2016)
    @report_form_data = get_report_data(businesses)
  end

  def create
    report_type = params['report'].delete(' ')
    year = params['year']

    report = case report_type
             when 'RegistrationForm'
               Reporting::Reports::RegistrationForm.new
             when 'DataForm'
               nil
             end

    num_reports = 0
    params['businesses'].each do |business_id, values|
      if values['email'] == '1'
        report.process_report(business_id.to_i, year)
        num_reports += 1
      end
    end
    plural = num_reports > 1 ? 's' : ''

    flash[:notice] = "#{num_reports} #{params['report']}#{plural} successfully emailed"
    redirect_to :root
  end

  def get_report_data(businesses)
    report_form_data = []
    businesses.each do |business|
      r = ReportFormData.new
      r.business_id = business.id
      r.business_name = business.name
      r.email = false
      r.email_contact_present = business.correspondence_contact.present?
      report_form_data << r
    end
    report_form_data
  end
end
