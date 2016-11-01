require 'rails_helper'

RSpec.describe 'CompanyOperators', js: true do
  describe 'GET /CompanyOperators' do
    it 'expects to be signed in with correct credentials' do
      sign_in('company_operator_0@pwpr.com', 'min700si')
      page.should have_content('Signed in successfully.')
    end

    it 'expects NOT to be signed in with incorrect credentials' do
      sign_in('company_operator_0@pwpr.com', 'wrong password')
      page.should have_content('Invalid Email or password')
    end
  end

  def sign_in(email, password)
    visit '/company_operators/sign_in'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in' # this be an Ajax button -- requires Selenium
  end
end
