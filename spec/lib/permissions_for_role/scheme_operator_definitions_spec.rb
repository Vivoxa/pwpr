require 'rails_helper'

RSpec.describe PermissionsForRole::SchemeOperatorDefinitions do
  context 'Constants' do
    it 'sets ROLES' do
      expect(subject.class::ROLES).to eq %w(sc_director sc_super_user sc_user).freeze
    end

    it 'sets PERMISSIONS' do
      expect(subject.class::PERMISSIONS).to eq %w(sc_users_r sc_users_w sc_users_e sc_users_d
                                                  co_users_r co_users_w co_users_d co_users_e
                                                  businesses_r businesses_w businesses_d businesses_e
                                                  schemes_r schemes_w schemes_d schemes_e
                                                  uploads_r uploads_w).freeze
    end
  end

  context 'When role is sc_director' do
    let(:role) { :sc_director }
    let(:definitions) do
      {
        schemes_r:    {checked: true, locked: true},
        schemes_w:    {checked: true, locked: true},
        schemes_e:    {checked: true, locked: true},
        schemes_d:    {checked: true, locked: true},

        sc_users_r:   {checked: true, locked: true},
        sc_users_w:   {checked: true, locked: true},
        sc_users_e:   {checked: true, locked: true},
        sc_users_d:   {checked: true, locked: true},

        co_users_r:   {checked: true, locked: true},
        co_users_w:   {checked: true, locked: true},
        co_users_e:   {checked: true, locked: true},
        co_users_d:   {checked: true, locked: true},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: true, locked: true},
        businesses_w: {checked: true, locked: true},
        businesses_d: {checked: true, locked: true},
        uploads_r:    {checked: true, locked: true},
        uploads_w:    {checked: true, locked: true}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end

  context 'When role is sc_super_user' do
    let(:role) { :sc_super_user }
    let(:definitions) do
      {
        schemes_r:    {checked: true, locked: true},
        schemes_w:    {checked: false, locked: false},
        schemes_e:    {checked: true, locked: true},
        schemes_d:    {checked: false, locked: false},

        sc_users_r:   {checked: true, locked: true},
        sc_users_w:   {checked: true, locked: true},
        sc_users_e:   {checked: true, locked: true},
        sc_users_d:   {checked: false, locked: false},

        co_users_r:   {checked: true, locked: true},
        co_users_w:   {checked: false, locked: false},
        co_users_e:   {checked: false, locked: false},
        co_users_d:   {checked: false, locked: false},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: true, locked: true},
        businesses_w: {checked: true, locked: true},
        businesses_d: {checked: false, locked: false},
        uploads_r:    {checked: true, locked: true},
        uploads_w:    {checked: false, locked: false}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end

  context 'When role is sc_user' do
    let(:role) { :sc_user }
    let(:definitions) do
      {
        schemes_r:    {checked: false, locked: true},
        schemes_w:    {checked: false, locked: true},
        schemes_e:    {checked: false, locked: true},
        schemes_d:    {checked: false, locked: true},

        sc_users_r:   {checked: false, locked: true},
        sc_users_w:   {checked: false, locked: true},
        sc_users_e:   {checked: false, locked: true},
        sc_users_d:   {checked: false, locked: true},

        co_users_r:   {checked: true, locked: true},
        co_users_w:   {checked: false, locked: false},
        co_users_e:   {checked: false, locked: false},
        co_users_d:   {checked: false, locked: false},

        businesses_r: {checked: true, locked: true},
        businesses_e: {checked: false, locked: false},
        businesses_w: {checked: false, locked: true},
        businesses_d: {checked: false, locked: true},
        uploads_r:    {checked: false, locked: false},
        uploads_w:    {checked: false, locked: false}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end
end
