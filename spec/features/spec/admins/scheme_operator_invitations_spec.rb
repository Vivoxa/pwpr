RSpec.describe '[Admin] Scheme Operator Invitations', js: true do

  {'normal_admin@pwpr.com' => 'normal_admin',
   'super_admin@pwpr.com' => 'super_admin'}.each do |email, user|
    context 'when inviting a scheme operator' do
      context "when #{user}" do
        context 'when form is completed with correct values' do
          it 'expects an invitation to be sent' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            wait_for_page_load('a', 'Invite Scheme Operator(Multiple Schemes)')
            hf = first(:css, '.card-block')
            within(hf) do
              click_on 'Scheme details'
            end
            wait_for_page_load('a', 'Invite new Scheme Operator')

            click_on('Invite new Scheme Operator')

            wait_for_page_load('h2','Invite new Scheme Operator: dans pack scheme')

            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr-test.com"
            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'

            # within '#scheme_operator_scheme_ids' do
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
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            wait_for_page_load('a', 'Invite Scheme Operator(Multiple Schemes)')
            hf = first(:css, '.card-block')
            within(hf) do
              click_on 'Scheme details'
            end

            wait_for_page_load('a', 'Invite new Scheme Operator')

            click_on('Invite new Scheme Operator')

            wait_for_page_load('h2','Invite new Scheme Operator: dans pack scheme')

            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'
            #
            # within '#scheme_operator_scheme_ids' do
            #   find("option[value='1']").click
            # end
            click_on 'Send an invitation'
            expect(page).to have_content('1 error prohibited this scheme operator from being saved:')
            expect(page).to have_content("Email can't be blank")
            click_link('Sign Out')
          end
        end

        context 'when name is not filled in' do
          it 'expects an invitation to be sent' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            wait_for_page_load('a', 'Invite Scheme Operator(Multiple Schemes)')
            hf = first(:css, '.card-block')
            within(hf) do
              click_on 'Scheme details'
            end

            wait_for_page_load('a', 'Invite new Scheme Operator')

            click_on('Invite new Scheme Operator')
            wait_for_page_load('h2','Invite new Scheme Operator: dans pack scheme')

            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr-test.com"

            # within '#scheme_operator_scheme_ids' do
            #   find("option[value='1']").click
            # end
            click_on 'Send an invitation'
            expect(page).to have_content('2 errors prohibited this scheme operator from being saved:')
            expect(page).to have_content("First name can't be blank")
            expect(page).to have_content("Last name can't be blank")
            click_link('Sign Out')
          end
        end

        context 'when scheme is not selected' do
          # not relevant as the scheme is sent via a hidden field now
          xit 'expects an error message' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            wait_for_page_load('a', 'Invite Scheme Operator(Multiple Schemes)')
            hf = first(:css, '.card-block')
            within(hf) do
              click_on 'Scheme details'
            end
            wait_for_page_load('a', 'Invite new Scheme Operator')

            click_on('Invite new Scheme Operator')

            wait_for_page_load('h2','Invite new Scheme Operator: dans pack scheme')

            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr-test.com"
            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'

            click_on 'Send an invitation'
            expect(page).to have_content('1 error prohibited this scheme operator from being saved:')
            expect(page).to have_content("Schemes can't be blank")
            click_link('Sign Out')
          end
        end
      end
    end
  end

  {'restricted_admin@pwpr.com' => 'restricted_admin'}.each do |email, user|
    context "when user is an Admin with #{user} role" do
      it 'expects the invite button NOT to be there' do
        sign_in('Admin', email, 'min700si')
        click_link('Schemes')
        wait_for_page_load('h3', 'dans pack scheme (active)')

        expect(page).not_to have_content('1-invite_scheme_operator')
        visit '/scheme_operators/invitation/new'
        expect(page).to have_content('You are not authorized to access this page.')
        click_link('Sign Out')
        expect(page).to have_content('Signed out successfully.')
      end
    end
  end
end