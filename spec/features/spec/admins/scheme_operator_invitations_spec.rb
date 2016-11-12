RSpec.describe 'Scheme Operator Invitations', js: true do

  {'restricted_admin@pwpr.com' => 'restricted_admin',
   'normal_admin@pwpr.com' => 'normal_admin',
   'super_admin@pwpr.com' => 'super_admin'}.each do |email, user|
    context 'when inviting a scheme operator' do
      context "when #{user}" do
        context 'when form is completed with correct values' do
          it 'expects an invitation to be sent' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            find_by_id('1-invite_scheme_operator').click
            expect(page).to have_content('Send invitation')
            id = rand(1000)
            fill_in 'Email', with: "new_scheme_operator#{id}@pwpr_test.com"
            fill_in 'Name', with: 'Doc Brown'

            within '#scheme_operator_scheme_ids' do
              find("option[value='1']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content("An invitation email has been sent to new_scheme_operator#{id}@pwpr_test.com.")
            click_link('Sign Out')
            expect(page).to have_content('Signed out successfully.')
          end
        end

        context 'when email is not filled in' do
          it 'expects an error message' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            find_by_id('1-invite_scheme_operator').click
            expect(page).to have_content('Send invitation')

            fill_in 'Name', with: 'Doc Brown'

            within '#scheme_operator_scheme_ids' do
              find("option[value='1']").click
            end
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
            find_by_id('1-invite_scheme_operator').click
            expect(page).to have_content('Send invitation')
            id = rand(1000)
            fill_in 'Email', with: "new_scheme_operator#{id}@pwpr_test.com"

            within '#scheme_operator_scheme_ids' do
              find("option[value='1']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content("An invitation email has been sent to new_scheme_operator#{id}@pwpr_test.com.")
            click_link('Sign Out')
          end
        end

        context 'when scheme is not selected' do
          it 'expects an error message' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            find_by_id('1-invite_scheme_operator').click
            expect(page).to have_content('Send invitation')
            id = rand(1000)
            fill_in 'Email', with: "new_scheme_operator#{id}@pwpr_test.com"
            fill_in 'Name', with: 'Doc Brown'

            click_on 'Send an invitation'
            expect(page).to have_content('1 error prohibited this scheme operator from being saved:')
            expect(page).to have_content("Schemes can't be blank")
            click_link('Sign Out')
          end
        end
      end
    end
  end
end