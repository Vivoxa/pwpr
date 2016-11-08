RSpec.describe 'scheme_operators/sign_in', js: true do

  it_behaves_like 'a user with valid credentials', 'scheme_operators/sign_in', 'sc_director_0@pwpr.com', 'min700si'

  it_behaves_like 'a user with invalid credentials', 'scheme_operators/sign_in', 'sc_director_0@pwpr.com', 'wrong password'

  it_behaves_like 'a field with placeholder text', 'scheme_operators/sign_in', 'Email', 'Email'

  it_behaves_like 'a field with placeholder text', 'scheme_operators/sign_in', 'Password', 'Password'

  it_behaves_like 'a button', 'scheme_operators/sign_in', 'Log in'
end
