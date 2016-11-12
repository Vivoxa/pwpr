RSpec.describe 'SchemeOperator', js: true do
  describe 'scheme_operators/sign_in' do
    it_behaves_like 'a user with valid credentials', 'SchemeOperator', 'sc_director_0@pwpr.com', 'min700si'

    it_behaves_like 'a user with invalid credentials', 'SchemeOperator', 'sc_director_0@pwpr.com', 'wrong password'

    it_behaves_like 'a field with placeholder text', 'scheme_operators/sign_in', 'Email', 'Email'

    it_behaves_like 'a field with placeholder text', 'scheme_operators/sign_in', 'Password', 'Password'

    it_behaves_like 'a button', 'scheme_operators/sign_in', 'Log in'

    context 'signing out' do
      before do
        sign_in('SchemeOperator', 'sc_director_0@pwpr.com', 'min700si')
        @sign_out_btn = find_by_id('signing_btn')
      end

      it 'expects to find a button for sign out' do
        expect(@sign_out_btn).not_to be_nil
      end

      it 'expects the sign out link to be correct' do
        expect(@sign_out_btn['href']).to include('/scheme_operators/sign_out')
      end
    end
  end
end
