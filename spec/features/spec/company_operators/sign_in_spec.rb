RSpec.describe 'CompanyOperator', js: true do
  describe 'company_operators/sign_in' do
    it_behaves_like 'a user with valid credentials', 'CompanyOperator', 'co_director_0@pwpr.com', 'min700si'

    it_behaves_like 'a user with invalid credentials', 'CompanyOperator', 'co_director_0@pwpr.com', 'wrong password'

    it_behaves_like 'a field with placeholder text', '/company_operators/sign_in', 'Email', 'Email'

    it_behaves_like 'a field with placeholder text', '/company_operators/sign_in', 'Password', 'Password'

    it_behaves_like 'a button', '/company_operators/sign_in', 'Log in'

    context 'signing out' do
      let(:sign_out_btn) { find_by_id('signing_btn') }
      before do
        sign_in('CompanyOperator', 'co_director_0@pwpr.com', 'min700si')
      end

      it 'expects to find a button for sign out' do
        expect(sign_out_btn).not_to be_nil
      end

      it 'expects the sign out link to be correct' do
        expect(sign_out_btn['href']).to include('/company_operators/sign_out')
      end
    end
  end
end
