RSpec.describe 'Admin', js: true do
  let(:definitions) {PermissionsForRole::AdminDefinitions.new}
  let(:all_permissions) {super_admin_definitions}

  before do
    sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
    page.driver.browser.manage.window.resize_to(1000,800)
  end

  after :each do
    visit '/admins/3/permissions'
    choose('role_restricted_admin')
    all_permissions.each do |key, permission|
      uncheck(key.to_s)
    end
    click_on 'Save Permissions'
  end

  context 'for super_admin role' do
    context 'when setting allowed permissions' do
      before :each do
        visit '/admins/3/permissions'
        choose('role_super_admin')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/admins/3/permissions'
      end

      it 'assigns the allowed permissions' do
        all_permissions.each do |key, permission|
          expect(page).to have_checked_field(key.to_s) if permission[:checked]
        end
      end
    end
  end

  context 'for normal_admin role' do
    let(:permissions) {normal_admin_definitions}

    context 'when setting permissions that are allowed' do
      before :each do
        visit '/admins/3/permissions'
        choose('role_normal_admin')
        permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/admins/3/permissions'
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
        visit '/admins/3/permissions'
        choose('role_normal_admin')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/admins/3/permissions'
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

  context 'for restricted_admin role' do
    let(:permissions) {restricted_admin_definitions}

    context 'when setting permissions that are allowed' do
      before :each do
        visit '/admins/3/permissions'
        choose('role_restricted_admin')
        permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/admins/3/permissions'
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
        visit '/admins/3/permissions'
        choose('role_restricted_admin')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/admins/3/permissions'
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
