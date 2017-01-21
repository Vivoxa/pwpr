RSpec.describe '[Scheme Operator] Company Operator Invitations', js: true do

  {'sc_director_0@pwpr.com' => 'director'}.each do |email, user|
    context 'when inviting a company operator' do
      context "when #{user}" do
        context 'when form is completed with correct values' do
          it 'expects an invitation to be sent' do
            sign_in('SchemeOperator', email, 'min700si')
            click_link('Schemes')
            wait_for_page_load('a', 'Invite Scheme Operator(Multiple Schemes)')

            hf = first(:css, '.card-block')
            within(hf) do
              click_on 'Scheme details'
            end
            wait_for_page_load('a', 'Invite new Member Contact')

            click_on('Invite new Member Contact')

            wait_for_page_load('h2','Invite Member Contact: dans pack scheme')

            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr-test.com"
            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'

            # within '#schemes_select' do
            #   find("option[value='1']").click
            # end
            #
            # within '#business_select' do
            #   find("option[value='1']").click
            # end
            click_on 'Send an invitation'
            expect(page).to have_content("An invitation email has been sent to #{id}@pwpr-test.com.")
            click_link('Sign Out')
            expect(page).to have_content('Signed out successfully.')
          end
        end

        context 'when email is not filled in' do
          it 'expects an error message' do
            sign_in('SchemeOperator', email, 'min700si')
            click_link('Schemes')
            wait_for_page_load('a', 'Invite Scheme Operator(Multiple Schemes)')

            hf = first(:css, '.card-block')
            within(hf) do
              click_on 'Scheme details'
            end
            wait_for_page_load('a', 'Invite new Member Contact')

            click_on('Invite new Member Contact')

            wait_for_page_load('h2','Invite Member Contact: dans pack scheme')

            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'

            # within '#schemes_select' do
            #   find("option[value='1']").click
            # end
            #
            # within '#business_select' do
            #   find("option[value='1']").click
            # end
            click_on 'Send an invitation'
            expect(page).to have_content('1 error prohibited this company operator from being saved:')
            expect(page).to have_content("Email can't be blank")
            click_link('Sign Out')
          end
        end

        context 'when name is not filled in' do
          it 'expects an invitation to be sent' do
            sign_in('SchemeOperator', email, 'min700si')
            click_link('Schemes')
            wait_for_page_load('a', 'Invite Scheme Operator(Multiple Schemes)')

            hf = first(:css, '.card-block')
            within(hf) do
              click_on 'Scheme details'
            end
            wait_for_page_load('a', 'Invite new Member Contact')

            click_on('Invite new Member Contact')

            wait_for_page_load('h2','Invite Member Contact: dans pack scheme')

            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr-test.com"

            within '#schemes_select' do
              find("option[value='1']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content('2 errors prohibited this company operator from being saved:')
            expect(page).to have_content("First name can't be blank")
            expect(page).to have_content("Last name can't be blank")
            click_link('Sign Out')
          end
        end
      end
    end
  end
  {'sc_super_user_0@pwpr.com' => 'super_user',
   'sc_user_0@pwpr.com' => 'user'}.each do |email, user|
    context "when user is a SchemeOperator with #{user} role" do
      it 'expects the invite button NOT to be there' do
        sign_in('SchemeOperator', email, 'min700si')
        click_link('Schemes')
        expect(page).not_to have_content('1-invite_scheme_operator')
        visit '/company_operators/invitation/new'
        expect(page).to have_content('You are not authorized to access this page.')
        click_link('Sign Out')
        expect(page).to have_content('Signed out successfully.')
      end
    end
  end
end