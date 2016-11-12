RSpec.describe 'CompanyOperator', js: true do
  describe 'company_operators/sign_in' do
    it_behaves_like 'a user with valid credentials', 'CompanyOperator', 'co_director_0@pwpr.com', 'min700si'

    it_behaves_like 'a user with invalid credentials', 'CompanyOperator', 'co_director_0@pwpr.com', 'wrong password'

    it_behaves_like 'a field with placeholder text', '/company_operators/sign_in', 'Email', 'Email'

    it_behaves_like 'a field with placeholder text', '/company_operators/sign_in', 'Password', 'Password'

    it_behaves_like 'a button', '/company_operators/sign_in', 'Log in'
  end
end
