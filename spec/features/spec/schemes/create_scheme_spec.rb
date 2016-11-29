RSpec.describe 'Create Scheme', js: true do
  describe '#index' do
    context 'when viewing all schemes' do
      context 'when the user has permissions to create a scheme' do
        it 'expects a link to create a new scheme to be present' do
          sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
          click_link('Schemes')
          expect(page).to have_link('New Scheme', href: '/schemes/new')
        end
      end

      context 'when the user DOES NOT have permissions to create a scheme' do
        it 'expects a link to create a new scheme NOT to be present' do
          sign_in('Admin', 'restricted_admin@pwpr.com', 'min700si')
          click_link('Schemes')
          expect(page).not_to have_link('New Scheme', href: '/schemes/new')
        end
      end
    end
  end
end