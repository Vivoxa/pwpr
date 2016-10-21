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

    context 'when calling permissions' do
      it 'expects to be redirected to sign in' do
        get :permissions, company_operator_id: CompanyOperator.last.id
        expect(response.status).to eq 302
        expect(response.body).to include('company_operators/sign_in')
      end
    end

    context 'when calling update_permissions' do
      it 'expects to be redirected to sign in' do
        put :update_permissions, company_operator_id: CompanyOperator.last.id
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
          get :index
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling show' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :show, id: co_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling update' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :update, id: co_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling destroy' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :destroy, id: co_marti.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling permissions' do
        it 'expects a CanCan AccessDenied error to be raised' do
          get :permissions, company_operator_id: CompanyOperator.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling update_permissions' do
        it 'expects a CanCan AccessDenied error to be raised' do
          put :update_permissions, company_operator_id: CompanyOperator.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end

    context 'when CompanyOperator has co_director role' do
      let(:co_director) { FactoryGirl.create(:company_operator_with_director) }
      before do
        sign_in co_director
      end

      it 'expects the co_director to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'expects the co_director to have access to the show action' do
        get :show, id: co_director.id
        expect(response.status).to eq 200
      end

      context 'when calling update' do
        it 'expects the company operator to be updated' do
          get :update, id: co_director.id, company_operator: {id: co_director.id}
          expect(subject.notice).to eq('User updated.')
          expect(response.status).to eq 302
        end
      end

      context 'when calling destroy' do
        it 'expects the company operator to be destroyed' do
          get :destroy, id: co_director.id
          expect(response.status).to eq 302
          expect(subject.notice).to eq('Jennifer with email: jennifer@back_to_the_future.com has been deleted.')
        end
      end

      context 'when calling permissions' do
        it 'expects the co_director to have access to the permissions action' do
          get :permissions, company_operator_id: CompanyOperator.last.id
          expect(response.status).to eq 200
        end

        it 'sets the correct user instance' do
          get :permissions, company_operator_id: CompanyOperator.last.id
          expect(assigns(:user)).to eq(CompanyOperator.last)
        end

        it 'sets the correct available_roles' do
          get :permissions, company_operator_id: CompanyOperator.last.id
          expect(assigns(:available_roles)).to eq(CompanyOperator::ROLES)
        end

        it 'sets the correct available_permissions' do
          get :permissions, company_operator_id: CompanyOperator.last.id
          expect(assigns(:available_permissions)).to eq(CompanyOperator::PERMISSIONS)
        end
      end

      context 'when calling update_permissions' do
        let(:params) { {company_operator_id: CompanyOperator.last.id, role: 'co_director', permissions: ['co_user_rwe']} }

        it 'expects the company operator permissions to be updated' do
          put :update_permissions, params
          expect(response.status).to eq 302
        end
      end
    end

    context 'when CompanyOperator has co_contact role' do
      let(:co_contact) { FactoryGirl.create(:company_operator_with_contact) }
      before do
        sign_in co_contact
      end

      it 'expects the admin to have access to the index action' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'expects the admin to have access to the show action' do
        get :show, id: co_contact.id
        expect(response.status).to eq 200
      end

      context 'when calling update' do
        it 'expects the company operator to be updated' do
          get :update, id: co_contact.id, company_operator: {id: co_contact.id}
          expect(subject.notice).to eq('User updated.')
          expect(response.status).to eq 302
        end
      end

      context 'when calling destroy' do
        it 'expects the co_contact to not have access to the destroy action' do
          get :destroy, id: co_contact.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling permissions' do
        it 'expects the co_contact to not have access to the destroy action' do
          get :permissions, company_operator_id: CompanyOperator.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end

      context 'when calling update_permissions' do
        it 'expects the co_contact to not have access to the destroy action' do
          put :update_permissions, company_operator_id: CompanyOperator.last.id
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end
  end
end
