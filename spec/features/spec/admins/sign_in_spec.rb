RSpec.describe 'Admin', js: true do
  describe 'admins/sign in' do
    it_behaves_like 'a user with valid credentials', 'admins/sign_in', 'super_admin@pwpr.com', 'min700si'

    it_behaves_like 'a user with invalid credentials', 'admins/sign_in', 'super_admin@pwpr.com', 'wrong password'

    it_behaves_like 'a field with placeholder text', 'admins/sign_in', 'Email', 'Email'

    it_behaves_like 'a field with placeholder text', 'admins/sign_in', 'Password', 'Password'

    it_behaves_like 'a button', 'admins/sign_in', 'Log in'
  end
end
