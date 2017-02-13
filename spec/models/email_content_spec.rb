require 'rails_helper'

RSpec.describe EmailContent, type: :model do
  it { is_expected.to belong_to(:email_content_type) }
  it { is_expected.to belong_to(:email_name) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:email_content_type_id) }
    it { is_expected.to validate_presence_of(:email_name_id) }
    it { is_expected.to validate_presence_of(:intro) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:footer) }

    describe '#email_type' do
      it 'expects an error if default type and scheme id is present' do
        email_content = EmailContent.new(intro:                 'intro',
                                         title:                 'title',
                                         body:                  'body',
                                         address:               'address',
                                         footer:                'footer',
                                         email_content_type_id: 2,
                                         email_name_id:         1,
                                         scheme_id:             1)
        email_content.save
        expect(email_content.errors.messages[:email_content_type_id]).to include('is default, cannot set a scheme id')
      end

      it 'expects NO errors if default type and scheme id is NOT present' do
        email_content = EmailContent.new(intro:                 'intro',
                                         title:                 'title',
                                         body:                  'body',
                                         address:               'address',
                                         footer:                'footer',
                                         email_content_type_id: 2,
                                         email_name_id:         1)
        email_content.save
        expect(email_content.errors.messages[:email_content_type_id]).to be_nil
      end

      it 'expects an error if scheme type and NO scheme id' do
        email_content = EmailContent.new(intro:                 'intro',
                                         title:                 'title',
                                         body:                  'body',
                                         address:               'address',
                                         footer:                'footer',
                                         email_content_type_id: 1,
                                         email_name_id:         1)
        email_content.save
        expect(email_content.errors.messages[:scheme_id]).to include('Scheme is required')
      end

      it 'expects NO errors if scheme type scheme id present' do
        email_content = EmailContent.new(intro:                 'intro',
                                         title:                 'title',
                                         body:                  'body',
                                         address:               'address',
                                         footer:                'footer',
                                         email_content_type_id: 1,
                                         email_name_id:         1,
                                         scheme_id:             1)
        email_content.save
        expect(email_content.errors.messages[:email_content_type_id]).to be_nil
      end
    end
  end
end
