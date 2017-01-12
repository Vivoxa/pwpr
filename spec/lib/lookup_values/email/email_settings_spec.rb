require 'rails_helper'

RSpec.describe LookupValues::Email::EmailSettings do
  it 'expects valid settings to be returned' do
    email_settings = described_class.for('registration_email')

    expect(email_settings['subject'] % {year: 2010}).to eq '[RESPONSE REQUIRED]: Registration form 2010'
  end
end
