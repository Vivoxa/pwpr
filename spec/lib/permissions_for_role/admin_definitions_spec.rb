require 'rails_helper'

RSpec.describe PermissionsForRole::AdminDefinitions do
  context 'Constants' do
    it 'assigns ROLES' do
      expect(subject.class::ROLES).to eq %w(super_admin normal_admin restricted_admin).freeze
    end

    it 'assigns PERMISSIONS' do
      expect(subject.class::PERMISSIONS).to eq %w(admins_r admins_w admins_e admins_d
                                                  email_names_r email_names_w email_names_e email_names_d
                                                  email_content_types_r email_content_types_w email_content_types_e email_content_types_d
                                                  sc_users_r sc_users_w sc_users_e sc_users_d
                                                  co_users_r co_users_w co_users_d co_users_e
                                                  businesses_r businesses_w businesses_d businesses_e
                                                  schemes_r schemes_w schemes_d schemes_e
                                                  uploads_r uploads_w scheme_businesses
                                                  contacts_r contacts_w contacts_d contacts_e).freeze
    end
  end

  context 'When role is super_admin' do
    let(:role) { :super_admin }
    let(:definitions) do
      {
        admins_r:              {checked: true, locked: true},
        admins_w:              {checked: true, locked: true},
        admins_e:              {checked: true, locked: true},
        admins_d:              {checked: true, locked: true},

        schemes_r:             {checked: true, locked: true},
        schemes_w:             {checked: true, locked: true},
        schemes_e:             {checked: true, locked: true},
        schemes_d:             {checked: true, locked: true},

        sc_users_r:            {checked: true, locked: true},
        sc_users_w:            {checked: true, locked: true},
        sc_users_e:            {checked: true, locked: true},
        sc_users_d:            {checked: true, locked: true},

        co_users_r:            {checked: true, locked: true},
        co_users_w:            {checked: true, locked: true},
        co_users_e:            {checked: true, locked: true},
        co_users_d:            {checked: true, locked: true},

        businesses_r:          {checked: true, locked: true},
        businesses_e:          {checked: true, locked: true},
        businesses_w:          {checked: true, locked: true},
        businesses_d:          {checked: true, locked: true},

        uploads_r:             {checked: true, locked: true},
        uploads_w:             {checked: true, locked: true},

        contacts_r:            {checked: true, locked: true},
        contacts_w:            {checked: true, locked: true},
        contacts_e:            {checked: true, locked: true},
        contacts_d:            {checked: true, locked: true},

        email_names_r:         {checked: true, locked: true},
        email_names_w:         {checked: true, locked: true},
        email_names_e:         {checked: true, locked: true},
        email_names_d:         {checked: true, locked: true},

        email_content_types_r: {checked: true, locked: true},
        email_content_types_w: {checked: true, locked: true},
        email_content_types_e: {checked: true, locked: true},
        email_content_types_d: {checked: true, locked: true}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(:super_admin)).to eq(definitions)
    end
  end

  context 'When role is normal_admin' do
    let(:role) { :normal_admin }
    let(:definitions) do
      {
        schemes_r:             {checked: true, locked: true},
        schemes_w:             {checked: false, locked: false},
        schemes_e:             {checked: true, locked: true},
        schemes_d:             {checked: false, locked: false},

        sc_users_r:            {checked: true, locked: true},
        sc_users_w:            {checked: true, locked: true},
        sc_users_e:            {checked: true, locked: true},
        sc_users_d:            {checked: false, locked: false},

        co_users_r:            {checked: true, locked: true},
        co_users_w:            {checked: true, locked: true},
        co_users_e:            {checked: true, locked: true},
        co_users_d:            {checked: false, locked: false},

        businesses_r:          {checked: true, locked: true},
        businesses_e:          {checked: true, locked: true},
        businesses_w:          {checked: true, locked: true},
        businesses_d:          {checked: false, locked: false},

        uploads_r:             {checked: true, locked: true},
        uploads_w:             {checked: false, locked: false},

        contacts_r:            {checked: true, locked: true},
        contacts_w:            {checked: true, locked: true},
        contacts_e:            {checked: true, locked: true},
        contacts_d:            {checked: false, locked: false},

        email_names_r:         {checked: true, locked: true},
        email_names_w:         {checked: true, locked: true},
        email_names_e:         {checked: true, locked: true},
        email_names_d:         {checked: true, locked: true},

        email_content_types_r: {checked: true, locked: true},
        email_content_types_w: {checked: true, locked: true},
        email_content_types_e: {checked: true, locked: true},
        email_content_types_d: {checked: true, locked: true}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end

  context 'When role is restricted_admin' do
    let(:role) { :restricted_admin }
    let(:definitions) do
      {
        schemes_r:             {checked: true, locked: true},
        schemes_w:             {checked: false, locked: true},
        schemes_e:             {checked: false, locked: false},
        schemes_d:             {checked: false, locked: true},

        sc_users_r:            {checked: true, locked: true},
        sc_users_w:            {checked: false, locked: false},
        sc_users_e:            {checked: false, locked: false},
        sc_users_d:            {checked: false, locked: true},

        co_users_r:            {checked: true, locked: true},
        co_users_w:            {checked: false, locked: false},
        co_users_e:            {checked: false, locked: false},
        co_users_d:            {checked: false, locked: false},

        businesses_r:          {checked: true, locked: true},
        businesses_e:          {checked: false, locked: false},
        businesses_w:          {checked: false, locked: true},
        businesses_d:          {checked: false, locked: true},

        uploads_r:             {checked: false, locked: false},
        uploads_w:             {checked: false, locked: true},

        contacts_r:            {checked: true, locked: true},
        contacts_w:            {checked: false, locked: false},
        contacts_e:            {checked: false, locked: false},
        contacts_d:            {checked: false, locked: true},

        email_names_r:         {checked: true, locked: true},
        email_names_w:         {checked: false, locked: false},
        email_names_e:         {checked: false, locked: false},
        email_names_d:         {checked: false, locked: true},

        email_content_types_r: {checked: true, locked: true},
        email_content_types_w: {checked: false, locked: false},
        email_content_types_e: {checked: false, locked: false},
        email_content_types_d: {checked: false, locked: true}
      }
    end

    it 'return the correct permissions definitions' do
      expect(subject.permissions_for_role(role)).to eq(definitions)
    end
  end
end
