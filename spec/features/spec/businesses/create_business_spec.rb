RSpec.describe 'Create Business', js: true do
  describe '#index' do
    context 'when viewing all businesses' do
      context 'when the user has permissions to create a business' do
        it 'expects a link to create a new business to be present' do
          sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
          click_link('Schemes')
          expect(page).to have_link('New Business', href: '/businesses/new')
        end
      end

      context 'when the user DOES NOT have permissions to create a business' do
        it 'expects a link to create a new business NOT to be present' do
          sign_in('Admin', 'restricted_admin@pwpr.com', 'min700si')
          click_link('Schemes')
          expect(page).not_to have_link('New Business', href: '/businesses/new')
        end
      end
    end
  end
end