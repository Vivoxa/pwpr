RSpec.describe 'Admin', js: true do
  let(:definitions) {PermissionsForRole::CompanyOperatorDefinitions.new}
  let(:all_permissions) {definitions.permissions_for_role('co_director')}

  before do
    sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
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
    let(:permissions) {definitions.permissions_for_role('co_super_user')}

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
    let(:permissions) {definitions.permissions_for_role('co_user')}

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
