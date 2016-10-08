
require 'rails_helper'

RSpec.describe Admin, type: :model do
  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.save
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
end
