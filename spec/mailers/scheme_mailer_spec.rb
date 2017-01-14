require 'rails_helper'

RSpec.describe SchemeMailer, type: :mailer do
  subject(:mailer) { described_class }
  let(:business) { Business.first }
  let(:email) { 'test@email.com' }
  let(:from_address) { 'dans_pack_scheme@app-pwpr.com' }
  let(:email_subject) { '[RESPONSE REQUIRED]: Registration form 2015' }
  let(:tmp_filename) { 'tmp_file_path' }
  let(:email_1) { mailer.registration_email(business, tmp_filename, 'tmp_file_path', 2015, email) }

  describe '#registration_email' do
    before do
      allow(File).to receive(:read).and_return('attachment')

      assert_emails 1 do
        email_1.deliver_now
      end
    end

    it 'expects the email from address to be correct' do
      assert_equal [from_address], email_1.from
    end

    it 'expects the email to be delivered to the correct address' do
      assert_equal [email], email_1.to
    end

    it 'expects the email to have the correct subject' do
      assert_equal email_subject, email_1.subject
    end

    it 'expects the email to have an attachment' do
      assert_equal tmp_filename, email_1.attachments[0].filename
    end
  end
end
