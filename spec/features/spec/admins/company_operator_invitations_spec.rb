RSpec.describe '[Admin] Company Operator Invitations', js: true do

  {'super_admin@pwpr.com' => 'super_admin',
   'normal_admin@pwpr.com' => 'normal_admin'}.each do |email, user|
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
            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'
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

            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'

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
            expect(page).to have_content('2 errors prohibited this company operator from being saved:')
            expect(page).to have_content("First name can't be blank")
            expect(page).to have_content("Last name can't be blank")
            click_link('Sign Out')
          end
        end
      end
    end
  end

  context 'when filling in the invitation form' do
    context 'when the scheme has been selected from the schemes dropdown' do
      if ENV['APP_HOST']
        xit 'expects the business dropdown to re-populate with the businesses associated with the chosen scheme' do
        end
      else
        it 'expects the business dropdown to re-populate with the businesses associated with the chosen scheme' do
          sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
          click_link('Schemes')
          find_by_id('2-invite_company_operator').click
          expect(page).to have_content('Send invitation')
          id = SecureRandom.uuid
          fill_in 'Email', with: "#{id}@pwpr_test.com"
          fill_in 'First name', with: 'Doc'
          fill_in 'Last name', with: 'Brown'

          within '#schemes_select' do
            find("option[value='5']").click
          end

          wait_for_ajax

          expect(page).not_to have_select('business_select', :options => ['dans pack business'])
          expect(page).not_to have_select('business_select', :options => ['my pack business'])
          expect(page).not_to have_select('business_select', :options => ['pack one business'])
          expect(page).not_to have_select('business_select', :options => ['pack for you'])

          expect(page).to have_select('business_select', :options => ['Synergy Business'])

          click_on 'Send an invitation'
          expect(page).to have_content("An invitation email has been sent to #{id}@pwpr_test.com.")
        end
      end
    end
  end

  context 'when admin does not have permissions to invite company operators' do
    {'restricted_admin@pwpr.com' => 'restricted_admin'}.each do |email, user|
      context "when user is an Admin with #{user} role" do
        it 'expects the invite button NOT to be there' do
          sign_in('Admin', email, 'min700si')
          click_link('Schemes')
          expect(page).not_to have_content('1-invite_company_operator')
          visit '/company_operators/invitation/new'
          expect(page).to have_content('You are not authorized to access this page.')

          click_link('Sign Out')
          expect(page).to have_content('Signed out successfully.')
        end
      end
    end
  end
end