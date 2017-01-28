RSpec.describe 'SchemeOperator', js: true do
  let(:definitions) {PermissionsForRole::SchemeOperatorDefinitions.new}
  let(:all_permissions) {sc_director_definitions}

  before do
    sign_in('SchemeOperator', 'sc_director_0@pwpr.com', 'min700si')
    page.driver.browser.manage.window.resize_to(1000,800)
  end

  after :each do
    visit '/scheme_operators/4/permissions'
    choose('role_sc_user')
    all_permissions.each do |key, permission|
      uncheck(key.to_s)
    end
    click_on 'Save Permissions'
    click_link('Sign Out')
  end

  context 'for sc_director role' do
    context 'when setting allowed permissions' do
      before :each do
        visit '/scheme_operators/4/permissions'
        choose('role_sc_director')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/scheme_operators/4/permissions'
      end

      it 'assigns the allowed permissions' do
        all_permissions.each do |key, permission|
          expect(page).to have_checked_field(key.to_s) if permission[:checked]
        end
      end
    end
  end

  context 'for sc_super_user role' do
    let(:permissions) {sc_super_user_definitions}

    context 'when setting permissions that are allowed' do
      before :each do
        visit '/scheme_operators/4/permissions'
        choose('role_sc_super_user')
        permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/scheme_operators/4/permissions'
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
        visit '/scheme_operators/4/permissions'
        choose('role_sc_super_user')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/scheme_operators/4/permissions'
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

  context 'for sc_user role' do
    let(:permissions) {sc_user_definitions}

    context 'when setting permissions that are allowed' do
      before :each do
        visit '/scheme_operators/4/permissions'
        choose('role_sc_user')
        permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/scheme_operators/4/permissions'
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
        visit '/scheme_operators/4/permissions'
        choose('role_sc_user')
        all_permissions.each do |key, permission|
          check(key.to_s) if permission[:checked]
        end
        click_on 'Save Permissions'
        visit '/scheme_operators/4/permissions'
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
