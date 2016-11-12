RSpec.describe 'Admin', js: true do
  describe 'admins/sign in' do
    it_behaves_like 'a user with valid credentials', 'Admin', 'super_admin@pwpr.com', 'min700si'

    it_behaves_like 'a user with invalid credentials', 'Admin', 'super_admin@pwpr.com', 'wrong password'

    it_behaves_like 'a field with placeholder text', '/admins/sign_in', 'Email', 'Email'

    it_behaves_like 'a field with placeholder text', '/admins/sign_in', 'Password', 'Password'

    it_behaves_like 'a button', '/admins/sign_in', 'Log in'

    it 'expects to find a button for sign out' do
      sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
      expect(find('a', text: "Sign Out")).to be_present
    end

    xit 'expects to find a button for viewing scheme operators' do
      sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
      visit '/admins'
    end
  end
end
