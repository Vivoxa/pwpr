shared_examples 'a user with valid credentials' do |url, email, password|
  it 'expects to be signed in with correct credentials' do
    sign_in(url, email, password)
    page.should have_content('Signed in successfully.')
  end
end
