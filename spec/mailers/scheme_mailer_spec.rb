require 'rails_helper'

RSpec.describe SchemeMailer, type: :mailer do
  subject(:mailer) { described_class }
  let(:email) { 'sc_director_0@pwpr.com' }
  let(:tmp_filename) { 'tmp_file_path' }
  let(:business) { Business.first }
  describe '#registration_email' do
    let(:registration_email) do
      mailer.registration_email(business,
                                tmp_filename,
                                'tmp_file_path',
                                2015,
                                SchemeOperator.first)
    end
    let(:email_subject) { '[RESPONSE REQUIRED]: Registration form 2015' }

    let(:from_address) { 'danspackscheme@app-pwpr.com' }

    before do
      allow(File).to receive(:read).and_return('attachment')
      assert_emails 1 do
        registration_email.deliver_now
      end
    end

    it 'expects the email from address to be correct' do
      assert_equal [from_address], registration_email.from
    end

    it 'expects the email to be delivered to the correct address' do
      assert_equal [email], registration_email.to
    end

    it 'expects the email to have the correct subject' do
      assert_equal email_subject, registration_email.subject
    end

    it 'expects the email to have an attachment' do
      assert_equal tmp_filename, registration_email.attachments[0].filename
    end
  end

  context 'when an exception occurs' do
    it 'expects an error to be logged' do
      allow(LookupValues::Email::EmailSettings).to receive(:for).and_raise('Scheme not found')
      expect(Rails.logger).to receive(:warn).with('SchemeMailer::registration_email() ERROR: Scheme not found')
      allow(File).to receive(:read).and_return('attachment')
      error_email = mailer.registration_email(business,
                                              tmp_filename,
                                              'tmp_file_path',
                                              2015,
                                              email)
      error_email.deliver_now
    end
  end

  describe '#scheme_director_info' do
    let(:business) { Business.first }
    let(:businesses) { business }
    let(:scheme) { business.scheme }
    let(:contact) { double(email: email, first_name: 'nigel', last_name: 'surtees') }
    let(:scheme_director_email) do
      mailer.scheme_director_info(businesses,
                                  scheme,
                                  2015,
                                  contact)
    end
    let(:email_subject) { '[INFO]: Registration forms emailed for 2015' }
    let(:from_address) { 'notifications@app-pwpr.com' }
    let(:tmp_filename) { 'recipients_registration_form_1_2015.pdf' }

    before do
      allow(File).to receive(:read).and_return('attachment')
      allow(Pdf::RegistrationFormEmailedBusinesses).to receive(:pdf).and_return(tmp_filename)
      allow(Pdf::RegistrationFormEmailedBusinesses).to receive(:cleanup)
      assert_emails 1 do
        scheme_director_email.deliver_now
      end
    end

    it 'expects the email from address to be correct' do
      assert_equal [from_address], scheme_director_email.from
    end

    it 'expects the email to be delivered to the correct address' do
      assert_equal [email], scheme_director_email.to
    end

    it 'expects the email to have the correct subject' do
      assert_equal email_subject, scheme_director_email.subject
    end

    it 'expects the email to have an attachment' do
      assert_equal tmp_filename, scheme_director_email.attachments[0].filename
    end
  end
end
