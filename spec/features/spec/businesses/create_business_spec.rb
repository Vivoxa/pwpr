RSpec.describe 'Create Business', js: true do
  describe '#index' do
    context 'when viewing all businesses' do
      after do
        click_link('Sign Out')
      end
      context 'when the user has permissions to create a business' do
        it 'expects a link to create a new business to be present' do
          sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
          visit '/businesses?scheme_id=1'
          expect(page).to have_link('New Member', href: '/businesses/new?scheme_id=1')
        end
      end

      context 'when the user DOES NOT have permissions to create a business' do
        it 'expects a link to create a new business NOT to be present' do
          sign_in('Admin', 'restricted_admin@pwpr.com', 'min700si')
          visit '/businesses?scheme_id=1'
          expect(page).not_to have_link('New Member', href: '/businesses/new?scheme_id=1')
        end
      end
    end
  end
end