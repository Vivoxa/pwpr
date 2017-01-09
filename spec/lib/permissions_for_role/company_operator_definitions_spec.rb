require 'rails_helper'

RSpec.describe PermissionsForRole::CompanyOperatorDefinitions do
  context 'Constants' do
    it 'sets ROLES' do
      expect(subject.class::ROLES).to eq %w(co_director co_super_user co_user).freeze
    end

    it 'sets PERMISSIONS' do
      expect(subject.class::PERMISSIONS).to eq %w(co_users_r co_users_w co_users_d co_users_e
                                                  businesses_r businesses_e).freeze
    end
  end

  context 'When role is co_director' do
    let(:role) { :co_director }
    let(:definitions) do
      {
        # co_users_r:   {checked: true, locked: true},
        # co_users_w:   {checked: true, locked: true},
        # co_users_e:   {checked: true, locked: true},
        # co_users_d:   {checked: true, locked: true},
        #
        # businesses_r: {checked: true, locked: true},
        # businesses_e: {checked: true, locked: true}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end

  context 'When role is co_super_user' do
    let(:role) { :co_super_user }
    let(:definitions) do
      {
        # co_users_r:   {checked: true, locked: true},
        # co_users_w:   {checked: true, locked: true},
        # co_users_e:   {checked: true, locked: true},
        # co_users_d:   {checked: false, locked: false},
        #
        # businesses_r: {checked: false, locked: false},
        # businesses_e: {checked: false, locked: false}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end

  context 'When role is co_user' do
    let(:role) { :co_user }
    let(:definitions) do
      {
        # co_users_r:   {checked: true, locked: true},
        # co_users_w:   {checked: false, locked: false},
        # co_users_e:   {checked: false, locked: false},
        # co_users_d:   {checked: false, locked: false},
        #
        # businesses_r: {checked: false, locked: false},
        # businesses_e: {checked: false, locked: true}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end
end
