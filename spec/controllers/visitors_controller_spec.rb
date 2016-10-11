RSpec.describe VisitorsController, type: :controller do
  context 'when Visitor is NOT signed in' do
    context 'when calling index' do
      it 'expects to have access to' do
        get :index
        expect(response.status).to eq 200
      end
    end
  end
end
