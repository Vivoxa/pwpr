RSpec.describe '[Admin] Company Operator Invitations', js: true do

  {'restricted_admin@pwpr.com' => 'restricted_admin',
   'normal_admin@pwpr.com' => 'normal_admin',
   'super_admin@pwpr.com' => 'super_admin'}.each do |email, user|
    context 'when inviting a company operator' do
      context "when #{user}" do
        context 'when form is completed with correct values' do
          it 'expects an invitation to be sent' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            find_by_id('2-invite_company_operator').click
            expect(page).to have_content('Send invitation')
            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr_test.com"
            fill_in 'Name', with: 'Doc Brown'

            within '#schemes_select' do
              find("option[value='2']").click
            end

            within '#business_select' do
              find("option[value='2']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content("An invitation email has been sent to #{id}@pwpr_test.com.")
            click_link('Sign Out')
            expect(page).to have_content('Signed out successfully.')
          end
        end

        context 'when email is not filled in' do
          it 'expects an error message' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            find_by_id('2-invite_company_operator').click
            expect(page).to have_content('Send invitation')

            fill_in 'Name', with: 'Doc Brown'

            within '#schemes_select' do
              find("option[value='2']").click
            end

            within '#business_select' do
              find("option[value='2']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content('1 error prohibited this company operator from being saved:')
            expect(page).to have_content("Email can't be blank")
            click_link('Sign Out')
          end
        end

        context 'when name is not filled in' do
          it 'expects an invitation to be sent' do
            sign_in('Admin', email, 'min700si')
            click_link('Schemes')
            find_by_id('2-invite_company_operator').click
            expect(page).to have_content('Send invitation')
            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr_test.com"

            within '#schemes_select' do
              find("option[value='2']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content("An invitation email has been sent to #{id}@pwpr_test.com.")
            click_link('Sign Out')
          end
        end
      end
    end
  end
end