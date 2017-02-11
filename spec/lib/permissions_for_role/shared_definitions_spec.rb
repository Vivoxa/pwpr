require 'rails_helper'

RSpec.describe PermissionsForRole::SharedDefinitions do
  context 'Constants' do
    it 'sets SHARED_PERMISSIONS' do
      expect(subject.class::SHARED_PERMISSIONS).to eq %w(sc_users_r sc_users_w sc_users_e sc_users_d
                                                         co_users_r co_users_w co_users_d co_users_e
                                                         businesses_r businesses_w businesses_d businesses_e
                                                         schemes_r schemes_w schemes_d schemes_e uploads_r uploads_w
                                                         scheme_businesses contacts_r contacts_w contacts_d contacts_e
                                                         email_contents_r email_contents_w email_contents_e email_contents_d).freeze
    end
  end
end
