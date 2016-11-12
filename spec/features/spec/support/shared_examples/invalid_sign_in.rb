shared_examples 'a user with invalid credentials' do |user_type, email, password|
  it 'expects NOT to be signed in with incorrect credentials' do
    sign_in(user_type, email, password)
    page.should have_content('Invalid Email or password')
  end
end
