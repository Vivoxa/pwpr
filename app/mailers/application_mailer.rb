class ApplicationMailer < ActionMailer::Base
  default from: from_email_address
  layout 'mailer'

  def from_email_address
    ENV['FROM_EMAIL'] || 'notifications@app-pwpr.com'
  end
end
