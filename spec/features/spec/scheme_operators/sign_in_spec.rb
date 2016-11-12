RSpec.describe 'SchemeOperator', js: true do
  describe 'scheme_operators/sign_in' do
    it_behaves_like 'a user with valid credentials', 'SchemeOperator', 'sc_director_0@pwpr.com', 'min700si'

    it_behaves_like 'a user with invalid credentials', 'SchemeOperator', 'sc_director_0@pwpr.com', 'wrong password'

    it_behaves_like 'a field with placeholder text', 'scheme_operators/sign_in', 'Email', 'Email'

    it_behaves_like 'a field with placeholder text', 'scheme_operators/sign_in', 'Password', 'Password'

    it_behaves_like 'a button', 'scheme_operators/sign_in', 'Log in'
  end
end
