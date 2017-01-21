# Preview all emails at http://localhost:3000/rails/mailers/scheme_mailer
class SchemeMailerPreview < ActionMailer::Preview
  def registration_email
    SchemeMailer.registration_email(Business.first,
                                    'registration_form_2015_NPWD-1.pdf',
                                    'public/registration_form_2015_NPWD-1.pdf',
                                    '2015',
                                    'nigel.surtees@hotmail.co.uk')
  end

  def  scheme_director_info
    scheme = Scheme.first
    SchemeMailer.scheme_director_info(scheme.businesses, scheme, '2015', SchemeOperator.first)
  end
end
