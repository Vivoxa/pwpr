def sign_in(url, email, password)
  visit url
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_on 'Log in' # this be an Ajax button -- requires Selenium
end
