class SchemeMailer < ApplicationMailer
  def registration_email(business, filename, file_path, year, recipient_email)
    attachments[filename] = File.read(file_path)
    @business = business
    @scheme = business.scheme
    @year = year
    @url = ENV['APP_CO_SIGN_IN_URL']

    email_settings = LookupValues::Email::EmailSettings.for('registration_email')
    subject = email_settings['subject'] % { year: year }

    mail(to: recipient_email, subject: subject)
  rescue => e
    Rails.logger.warn("SchemeMailer::registration_email() ERROR: #{e.message}")
  end

  def scheme_director_info(businesses, scheme, year, recipient_email)

    file_path = Pdf::RegistrationFormEmailedBusinesses.pdf(businesses, year)

    attachments[filename] = File.read(file_path)

    @scheme = scheme
    @year = year

    mail(to: recipient_email, subject: subject)
  end
end
