RSpec.describe '[Company Operator] Company Operator Invitations', js: true do

  { 'co_super_user_0@pwpr.com' => { type: 'super_user', business_id: 2 },
    'co_director_0@pwpr.com' => { type: 'director', business_id: 1 }  }.each do |email, user|
    context 'when inviting a company operator' do
      context "when #{user[:type]}" do
        context 'when form is completed with correct values' do
          xit 'expects an invitation to be sent' do
            sign_in('CompanyOperator', email, 'min700si')
            click_link('My Business')
            find_by_id("#{user[:business_id]}-invite_company_operator").click
            expect(page).to have_content('Send invitation')
            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr-test.com"
            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'

            within '#schemes_select' do
              find("option[value='#{user[:business_id]}']").click
            end

            within '#business_select' do
              find("option[value='#{user[:business_id]}']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content("An invitation email has been sent to #{id}@pwpr-test.com.")
            click_link('Sign Out')
            expect(page).to have_content('Signed out successfully.')
          end
        end

        context 'when email is not filled in' do
          xit 'expects an error message' do
            sign_in('CompanyOperator', email, 'min700si')
            click_link('My Business')
            find_by_id("#{user[:business_id]}-invite_company_operator").click
            expect(page).to have_content('Send invitation')

            fill_in 'First name', with: 'Doc'
            fill_in 'Last name', with: 'Brown'

            within '#schemes_select' do
              find("option[value='#{user[:business_id]}']").click
            end

            within '#business_select' do
              find("option[value='#{user[:business_id]}']").click
            end
            click_on 'Send an invitation'
            expect(page).to have_content('1 error prohibited this company operator from being saved:')
            expect(page).to have_content("Email can't be blank")
            click_link('Sign Out')
          end
        end

        context 'when name is not filled in' do
          xit 'expects an invitation to be sent' do
            sign_in('CompanyOperator', email, 'min700si')
            click_link('My Business')
            find_by_id("#{user[:business_id]}-invite_company_operator").click
            expect(page).to have_content('Send invitation')
            id = SecureRandom.uuid
            fill_in 'Email', with: "#{id}@pwpr-test.com"

            within '#schemes_select' do
              find("option[value='#{user[:business_id]}']").click
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
  {'co_user_0@pwpr.com' => 'user'}.each do |email, user|
    context "when user is a CompanyOperator with #{user} role" do
      xit 'expects the invite button NOT to be there' do
        sign_in('CompanyOperator', email, 'min700si')
        click_link('My Business')
        expect(page).not_to have_content('1-invite_company_operator')
        visit '/company_operators/invitation/new'
        expect(page).to have_content('You are not authorized to access this page.')
        click_link('Sign Out')
        expect(page).to have_content('Signed out successfully.')
      end
    end
  end
end