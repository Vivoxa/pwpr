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
    @scheme = scheme
    @year = year
    @url = ENV['APP_SO_SIGN_IN_URL']

    file_path = Pdf::RegistrationFormEmailedBusinesses.pdf(businesses, year)

    email_settings = LookupValues::Email::EmailSettings.for('scheme_director_info')

    subject = email_settings['subject'] % { year: year }
    report_name = email_settings['report_name'] % { scheme_id: scheme.id, year: year }

    attachments[report_name] = File.read(file_path)

    mail(to: recipient_email, subject: subject)
  end
end
