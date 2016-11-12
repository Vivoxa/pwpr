shared_examples 'a user with valid credentials' do |user_type, email, password|
  it 'expects to be signed in with correct credentials' do
    sign_in(user_type, email, password)
    page.should have_content('Signed in successfully.')
  end
end
