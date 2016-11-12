RSpec.describe 'Admin', js: true do
  describe 'admins/sign in' do
    it_behaves_like 'a user with valid credentials', 'Admin', 'super_admin@pwpr.com', 'min700si'

    it_behaves_like 'a user with invalid credentials', 'Admin', 'super_admin@pwpr.com', 'wrong password'

    it_behaves_like 'a field with placeholder text', '/admins/sign_in', 'Email', 'Email'

    it_behaves_like 'a field with placeholder text', '/admins/sign_in', 'Password', 'Password'

    it_behaves_like 'a button', '/admins/sign_in', 'Log in'

    context 'signing out' do
      let(:sign_out_btn) { nil }
      before do
        sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
        @sign_out_btn = find('a', text: "Sign Out")
      end

      it 'expects to find a button for sign out' do
        expect(@sign_out_btn).to be_present
      end

      it 'expects the sign out link to be correct' do
        expect(@sign_out_btn['href']).to include('/admins/sign_out')
      end
    end

    xit 'expects to find a button for viewing scheme operators' do
      sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
      visit '/admins'
    end
  end
end
