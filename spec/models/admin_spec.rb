require 'rails_helper'

RSpec.describe Admin, type: :model do
  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.save
  end

  describe 'Constants' do
    it 'load the ROLES constant' do
      expect(subject.class::ROLES).not_to be_nil
    end

    it 'expects ROLES to be set correctly' do
      expect(subject.class::ROLES).to eq %w(full_access)
    end

    it 'load the PERMISSIONS constant' do
      expect(subject.class::PERMISSIONS).not_to be_nil
    end

    it 'expects PERMISSIONS to be set correctly' do
      expect(subject.class::PERMISSIONS).to eq %w()
    end
  end

  context 'Roles' do
    it 'expects the correct roles to be available' do
      expect(Admin.available_role_names).to eq %w(full_access)
    end

    it 'expects full_access to be an available role' do
      expect(subject.allowed_role?(:full_access)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the Admin to have that role' do
        subject.add_role :full_access
        expect(subject.has_role?(:full_access)).to be true
        expect(subject.full_access?).to be true
        subject.full_access!
        expect(subject.full_access?).to be true
        expect(subject.has_role?(:full_access)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the Admin to NOT have that role' do
        subject.add_role :full_access
        expect(subject.has_role?(:full_access)).to be true
        subject.remove_role :full_access
        expect(subject.has_role?(:full_access)).to be false
      end
    end
  end
  context 'abilities' do
    context 'with Role full_access' do
      let(:admin_full_access) { FactoryGirl.create(:admin_full_access) }
      let(:ability) { Ability.new(admin_full_access) }

      it_behaves_like 'an admin manager'

      it_behaves_like 'a company operator manager'

      it_behaves_like 'a scheme manager'

      it_behaves_like 'a scheme operator manager'

      it_behaves_like 'a registration manager'
    end

    context 'with no Role' do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:ability) { Ability.new(admin) }

      it_behaves_like 'NOT an admin manager'

      it_behaves_like 'NOT a company operator manager'

      it_behaves_like 'NOT a scheme operator manager'

      it_behaves_like 'NOT a scheme manager'

      it_behaves_like 'NOT a registration manager'
    end
  end
end
