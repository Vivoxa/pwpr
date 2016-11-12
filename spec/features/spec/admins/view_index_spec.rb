RSpec.describe 'Admin', js: true do
  describe 'viewing all admins in the index page' do
    context 'when an admin is signed in with the correct credentials' do
      it 'expects to view the admins its entitled to see' do
        sign_in('Admin', 'super_admin@pwpr.com', 'min700si')
        visit 'admins'
      end
    end
  end
end
