RSpec.describe 'SchemeOperator', js: true do
  let(:definitions) {PermissionsForRole::CompanyOperatorDefinitions.new}
  let(:all_permissions) {co_director_definitions}

  before do
    sign_in('SchemeOperator', 'sc_director_0@pwpr.com', 'min700si')
    page.driver.browser.manage.window.resize_to(1000,800)
  end

  after :each do
    visit '/company_operators/6/permissions'
    choose('role_co_user')
    all_permissions.each do |key, permission|
      uncheck(key.to_s)
    end
    click_on 'Save Permissions'
  end

  context 'for co_director role' do
    context 'when setting allowed permissions' do
      before :each do
        visit '/company_operators/6/permissions'
        choose('role_co_director')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/company_operators/6/permissions'
      end

      it 'assigns the allowed permissions' do
        all_permissions.each do |key, permission|
          expect(page).to have_checked_field(key.to_s) if permission[:checked]
        end
      end
    end
  end

  context 'for co_super_user role' do
    let(:permissions) {co_super_user_definitions}

    context 'when setting permissions that are allowed' do
      before :each do
        visit '/company_operators/6/permissions'
        choose('role_co_super_user')
        permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/company_operators/6/permissions'
      end

      it 'assigns the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_checked_field(key.to_s) if permission[:checked]
        end
      end

      it 'DOES NOT assign the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_unchecked_field(key.to_s) if !permission[:checked] && permission[:locked]
        end
      end
    end

    context 'when setting permissions that are not allowed' do
      before :each do
        visit '/company_operators/6/permissions'
        choose('role_co_super_user')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/company_operators/6/permissions'
      end

      it 'assigns the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_checked_field(key.to_s) if permission[:checked]
        end
      end

      it 'DOES NOT assign the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_unchecked_field(key.to_s) if !permission[:checked] && permission[:locked]
        end
      end
    end
  end

  context 'for co_user role' do
    let(:permissions) {co_user_definitions}

    context 'when setting permissions that are allowed' do
      before :each do
        visit '/company_operators/6/permissions'
        choose('role_co_user')
        permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/company_operators/6/permissions'
      end

      it 'assigns the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_checked_field(key.to_s) if permission[:checked]
        end
      end

      it 'DOES NOT assign the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_unchecked_field(key.to_s) if !permission[:checked] && permission[:locked]
        end
      end
    end

    context 'when setting permissions that are not allowed' do
      before :each do
        visit '/company_operators/6/permissions'
        choose('role_co_user')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/company_operators/6/permissions'
      end

      it 'assigns the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_checked_field(key.to_s) if permission[:checked]
        end
      end

      it 'DOES NOT assign the allowed permissions' do
        permissions.each do |key, permission|
          expect(page).to have_unchecked_field(key.to_s) if !permission[:checked] && permission[:locked]
        end
      end
    end
  end
end
