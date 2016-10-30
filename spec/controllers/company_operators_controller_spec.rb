require 'rails_helper'

RSpec.describe CompanyOperatorsController, type: :controller do
  context 'when a scheme operator is signed in' do
    let(:scheme_operator) { SchemeOperator.new }
    let(:business) do
      Business.create(scheme_id:     scheme_operator.schemes.first.id,
                      NPWD:          'kgkgk',
                      SIC:           'khgifk',
                      name:          'business 1',
                      membership_id: 'mem-1',
                      company_no:    '123456789')
    end
    before do
      scheme_operator.email = 'jennifer@back_to_the_future.com'
      scheme_operator.name = 'Jennifer'
      scheme_operator.password = 'mypassword'
      scheme_operator.confirmed_at = DateTime.now
      scheme_operator.schemes = [Scheme.create(name: 'test scheme', active: true)]
      scheme_operator.add_role :sc_director
      # TODO: these will have to be tweaked when roles are finished
      scheme_operator.add_role :co_users_r
      scheme_operator.add_role :co_users_e
      scheme_operator.add_role :co_users_w
      scheme_operator.add_role :co_users_d
      scheme_operator.save
      sign_in scheme_operator
    end

    it 'expects the co_director to have access to the index action' do
      company_operator = CompanyOperator.find(3)
      company_operator.approved = true
      company_operator.business = business
      company_operator.save
      get 'index'
      expect(response.status).to eq 200
      expect(assigns(:company_operators)).to eq [company_operator]
    end

    context 'when an invitation has NOT been accepted' do
      it 'expects a collection of scheme operators' do
        company_operator = CompanyOperator.create(email:              'invited@pwpr.com',
                                                  password:           'my_password',
                                                  business_id:        business.id,
                                                  invitation_sent_at: DateTime.now)
        get 'invited_not_accepted'
        object = assigns(:company_operators).first
        expect(object).to be_a CompanyOperator
        expect(object.id).to eq company_operator.id
      end
    end

    context 'when an invitation HAS been accepted but not approved' do
      it 'expects a collection of scheme operators' do
        company_operator = CompanyOperator.create(email:                  'invited@pwpr.com',
                                                  password:               'my_password',
                                                  business_id:            business.id,
                                                  invitation_sent_at:     DateTime.now - 5.days,
                                                  invitation_accepted_at: DateTime.now,
                                                  confirmation_sent_at:   DateTime.now - 5.days,
                                                  confirmed_at:           DateTime.now,
                                                  approved:               false)
        get 'pending'
        object = assigns(:company_operators).first
        expect(object).to be_a CompanyOperator
        expect(object.id).to eq company_operator.id
      end
    end

    it 'expects the admin to have access to the index action' do
      get 'index'
      expect(response.status).to eq 200
    end
  end

  context 'when company operator is NOT signed in' do
    context 'when not activated' do
      let(:co_not_activated) { FactoryGirl.create(:company_operator_with_director_inactive) }
      it 'expects a not activated error to be raised' do
        sign_in co_not_activated
        get :index
        expect(flash[:alert]).to eq 'Your account has not been approved by your administrator yet.'
      end
    end
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
        CompanyOperator.available_roles.each do |role|
          co_marti.remove_role role
        end
        sign_in co_marti
      end
      after do
        sign_out co_marti
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
        CompanyOperator::PERMISSIONS.each do |role|
          co_director.add_role role
        end
        sign_in co_director
      end

      after do
        sign_out co_director
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
          expect(subject.notice).to eq('CompanyOperator was successfully updated.')
          expect(response.status).to eq 302
        end
      end

      context 'when calling destroy' do
        it 'expects the company operator to be destroyed' do
          get :destroy, id: co_director.id
          expect(response.status).to eq 302
          expect(subject.notice).to include('has been deleted.')
          expect(CompanyOperator.where(id: co_director.id)).to be_empty
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
        co_contact.add_role :co_users_w
        co_contact.add_role :co_users_e
        sign_in co_contact
      end

      after do
        co_contact.remove_role :co_users_w
        co_contact.remove_role :co_users_e
        sign_out co_contact
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
          expect(subject.notice).to eq('CompanyOperator was successfully updated.')
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

      context 'without edit and write role' do
        before do
          co_contact.remove_role :co_users_w
          co_contact.remove_role :co_users_e
          co_contact.remove_role :co_users_r
          sign_in co_contact
        end

        after do
          sign_out co_contact
        end

        context 'when calling permissions' do
          it 'expects the co_contact to not have access to the permissions action' do
            get :permissions, company_operator_id: CompanyOperator.last.id
            expect(flash[:alert]).to be_present
            expect(flash[:alert]).to eq 'You are not authorized to access this page.'
          end
        end

        context 'when calling update_permissions' do
          it 'expects the co_contact to not have access to the permissions action' do
            put :update_permissions, company_operator_id: CompanyOperator.last.id
            expect(flash[:alert]).to be_present
            expect(flash[:alert]).to eq 'You are not authorized to access this page.'
          end
        end
      end
    end
  end
end
