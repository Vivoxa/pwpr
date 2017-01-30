class ApplicationMailer < ActionMailer::Base
  default from: ENV['FROM_EMAIL'] || 'notifications@app-pwpr.com'
  layout 'mailer'
end
