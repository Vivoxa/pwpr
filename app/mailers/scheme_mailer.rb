class SchemeMailer < ApplicationMailer

  def registration_email(business, filename, file_path, year)
    attachments[filename] = File.read(file_path)
    @business = business
    @scheme = business.scheme
    @year = year
    @url  = 'http://app-pwpr.com/sign_in'
    mail(to: 'nigel@surtees.com', subject: "[RESPONSE REQUIRED]: Registration form #{year}")
  end
end
