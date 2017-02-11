class SchemeMailer < ApplicationMailer
  def scheme_director_info(businesses, scheme, year, contact)
    @scheme = scheme
    @year = year
    @url = ENV['APP_SO_SIGN_IN_URL']
    @contact = contact

    file_path = Pdf::RegistrationFormEmailedBusinesses.pdf(businesses, year)

    subject = set_subject(year, 'scheme_director_info')

    email_settings = LookupValues::Email::Settings.for('scheme_director_info')
    report_name = email_settings['report_name'] % {scheme_id: scheme.id, year: year}

    attachments[report_name] = File.read(file_path)

    result = mail(to: contact.email, subject: subject)
    Pdf::RegistrationFormEmailedBusinesses.cleanup(@scheme, year)

    result
  end

  def registration_email(business, filename, file_path, year, contact)
    Rails.logger.info('Setting email type')
    email_type = 'registration_email'

    Rails.logger.info('Setting attachments')
    attachments[filename] = File.read(file_path)

    business = business
    scheme = business.scheme

    setup_email_contents(contact, email_type, scheme, year)

    Rails.logger.info('Setting subject')
    subject = set_subject(year, email_type)

    Rails.logger.info('Setting from address')
    from_address = scheme.email_friendly_name

    Rails.logger.info('Setting email content')
    email_content(scheme, email_type)

    Rails.logger.info('Mailing')
    mail(to: contact.email, from: from_address, subject: subject)
  rescue => e
    Rails.logger.warn("SchemeMailer::registration_email() ERROR: #{e.message}")
  end

  def setup_email_contents(contact, email_type, scheme, year)
    Rails.logger.info('Setting intro')
    @intro = substitute_values_registration_email(intro(scheme, email_type), contact, scheme, year)

    Rails.logger.info('Setting title')
    @title = substitute_values_registration_email(title(scheme, email_type), contact, scheme, year)

    Rails.logger.info('Setting body lines')
    body_details = body_lines(scheme, email_type)
    @body_lines = []
    body_details.each do |body_detail|
      @body_lines << substitute_values_registration_email(body_detail, contact, scheme, year)
    end
    Rails.logger.info('Setting address lines')
    address_details = address_lines(scheme, email_type)
    @address_details = []

    address_details.each do |addy_detail|
      @address_details << substitute_values_registration_email(addy_detail, contact, scheme, year)
    end
    Rails.logger.info('Setting footer')
    @footer = footer(scheme, email_type)
  end

  private

  def substitute_values_registration_email(line, contact, scheme, year)
    Rails.logger.info("LINE: #{line}")

    variable_mappings('registration_email').each do |var|
      line = case var
             when 'first_name'
               line.gsub('<first_name>', contact.first_name)
             when 'scheme_name'
               line.gsub('<scheme_name>', scheme.name)
             when 'year'
               line.gsub('<year>', year)
             end
    end
    line
  end

  def email_content(scheme, email_type)
    @email_content ||= EmailContent.for_scheme(scheme, email_type)
  end

  def variable_mappings(email_name)
    @variable_mappings = LookupValues::Email::ContentVariables.for(email_name)
  end

  def intro(scheme, email_type)
    email_content(scheme, email_type).intro
  end

  def title(scheme, email_type)
    email_content(scheme, email_type).title
  end

  def body_lines(scheme, email_type)
    email_content(scheme, email_type).body_lines
  end

  def address_lines(scheme, email_type)
    email_content(scheme, email_type).address_lines
  end

  def footer(scheme, email_type)
    email_content(scheme, email_type).footer
  end

  def set_subject(year, email_name)
    email_settings = LookupValues::Email::Settings.for(email_name)
    email_settings['subject'] % {year: year}
  end
end
