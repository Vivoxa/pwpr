require 'rails_helper'

RSpec.describe CompanyOperatorsController, type: :controller do
  context 'when company operator is NOT signed in' do
    context 'when calling index' do
      it 'expects to be redirected to sign in' do
        get :index
        expect(response.status).to eq 302
        expect(response.body).to include('company_operators/sign_in')
      end
    end

    context 'when calling show' do
      it 'expects to be redirected to sign in' do
        get :show, id: CompanyOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('company_operators/sign_in')
      end
    end

    context 'when calling update' do
      it 'expects to be redirected to sign in' do
        get :update, id: CompanyOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('company_operators/sign_in')
      end
    end

    context 'when calling destroy' do
      it 'expects to be redirected to sign in' do
        get :destroy, id: CompanyOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('company_operators/sign_in')
      end
    end
  end

  context 'when company operator is signed in' do
    context 'when CompanyOperator does NOT have the director role' do
      let(:co_marti) { FactoryGirl.create(:company_operator) }
      before do
        sign_in co_marti
      end
      context 'when calling index' do
        it 'expects a CanCan AccessDenied error to be raised' do
          expect { get 'index' }.to raise_error(CanCan::AccessDenied)
        end
      end

      context 'when calling show' do
        it 'expects a CanCan AccessDenied error to be raised' do
          expect { get :show, id: co_marti.id }.to raise_error(CanCan::AccessDenied)
        end
      end

      context 'when calling update' do
        it 'expects a CanCan AccessDenied error to be raised' do
          expect { get :update, id: co_marti.id }.to raise_error(CanCan::AccessDenied)
        end
      end

      context 'when calling destroy' do
        it 'expects a CanCan AccessDenied error to be raised' do
          expect { get :update, id: co_marti.id }.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    context 'when CompanyOperator has co_director role' do
      let(:co_director) { FactoryGirl.create(:company_operator_with_director) }
      before do
        sign_in co_director
      end

      it 'expects the admin to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'expects the admin to have access to the show action' do
        get :show, id: co_director.id
        expect(response.status).to eq 200
      end
    end
  end
end
