shared_examples 'a user with invalid credentials' do |url, email, password|
  if url
    it 'expects NOT to be signed in with incorrect credentials' do
      sign_in(url, email, password)
      page.should have_content('Invalid Email or password')
    end
  end
end

