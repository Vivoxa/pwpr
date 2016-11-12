def sign_in(user_type, email, password)
  case user_type
  when 'Admin'
    visit '/admins/sign_in'
  when 'SchemeOperator'
    sign_in_btn_id = 'sc_login'
  when 'CompanyOperator'
    sign_in_btn_id = 'co_login'
  end

  if sign_in_btn_id
    visit '/'
    find_by_id('sign_in_out').click
    find_by_id(sign_in_btn_id).click
  end

  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_on 'Log in' # this be an Ajax button -- requires Selenium
end