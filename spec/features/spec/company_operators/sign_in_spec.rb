RSpec.describe 'company_operators/sign_in', js: true do

  it_behaves_like 'a user with valid credentials', 'company_operators/sign_in', 'co_director_0@pwpr.com', 'min700si'

  it_behaves_like 'a user with invalid credentials', 'company_operators/sign_in', 'co_director_0@pwpr.com', 'wrong password'

  it_behaves_like 'a field with placeholder text', 'company_operators/sign_in', 'Email', 'Email'

  it_behaves_like 'a field with placeholder text', 'company_operators/sign_in', 'Password', 'Password'

  it_behaves_like 'a button', 'company_operators/sign_in', 'Log in'
end
