
require 'rails_helper'

RSpec.describe SchemeOperator, type: :model do
  before do
    subject.email = 'nigelsurtees@wvivoxa.com'
    subject.password = 'khgsdfgaskgfdkag'
    subject.save
  end

  context 'Roles' do
    it 'expects the correct roles to be available' do
      expect(SchemeOperator.available_role_names).to eq %w(scheme_owner scheme_full_access scheme_user_r scheme_user_rw)
    end

    it 'expects scheme_owner to be an available role' do
      expect(subject.allowed_role?(:scheme_owner)).to be true
    end

    it 'expects scheme_full_access to be an available role' do
      expect(subject.allowed_role?(:scheme_full_access)).to be true
    end

    it 'expects scheme_user_r to be an available role' do
      expect(subject.allowed_role?(:scheme_user_r)).to be true
    end

    it 'expects scheme_user_rw to be an available role' do
      expect(subject.allowed_role?(:scheme_user_rw)).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end

    context 'when assigning a role' do
      it 'expects the SchemeOperator to have that role' do
        subject.add_role :scheme_owner
        expect(subject.has_role?(:scheme_owner)).to be true
        expect(subject.scheme_owner?).to be true
        subject.scheme_full_access!
        expect(subject.scheme_full_access?).to be true
        expect(subject.has_role?(:scheme_full_access)).to be true
      end
    end

    context 'when removing a role' do
      it 'expects the SchemeOperator to NOT have that role' do
        subject.add_role :scheme_owner
        expect(subject.has_role?(:scheme_owner)).to be true
        subject.remove_role :scheme_owner
        expect(subject.has_role?(:scheme_owner)).to be false
      end
    end
  end
end
