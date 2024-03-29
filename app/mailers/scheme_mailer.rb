class SchemeMailer < ApplicationMailer
  def registration_email(business, filename, file_path, year, contact)
    attachments[filename] = File.read(file_path)
    @business = business
    @scheme = business.scheme
    @year = year
    @url = ENV['APP_CO_SIGN_IN_URL']
    @contact = contact

    email_settings = LookupValues::Email::EmailSettings.for('registration_email')
    subject = email_settings['subject'] % {year: year}

    from_address = @scheme.email_friendly_name

    mail(to: contact.email, from: from_address, subject: subject)
  rescue => e
    Rails.logger.warn("SchemeMailer::registration_email() ERROR: #{e.message}")
  end

  def scheme_director_info(businesses, scheme, year, recipient)
    @scheme = scheme
    @year = year
    @url = ENV['APP_SO_SIGN_IN_URL']
    @recipient = recipient

    file_path = Pdf::RegistrationFormEmailedBusinesses.pdf(businesses, year)

    email_settings = LookupValues::Email::EmailSettings.for('scheme_director_info')

    subject = email_settings['subject'] % {year: year}
    report_name = email_settings['report_name'] % {scheme_id: scheme.id, year: year}

    attachments[report_name] = File.read(file_path)

    result = mail(to: recipient.email, subject: subject)
    Pdf::RegistrationFormEmailedBusinesses.cleanup(@scheme, year)

    result
  end
end
