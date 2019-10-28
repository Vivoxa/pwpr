RSpec.describe SchemeOperators::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:scheme_operator]
  end

  context 'when scheme operator is NOT signed in' do
    context 'when calling create' do
      it 'expects to be redirected to sign in' do
        post :create, params: {}
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end
  end

  context 'when scheme operator is signed in' do
    let(:scheme_operator_with_director) { FactoryGirl.create(:scheme_operator_with_director) }

    context 'when SchemeOperator has not been approved' do
      let(:not_approved_scheme_operator) { FactoryGirl.create(:not_approved_scheme_operator) }
      before do
        sign_in not_approved_scheme_operator
      end

      after do
        sign_out not_approved_scheme_operator
      end

      context 'when calling new' do
        it 'expects an error to be raised' do
          post :create, email: 'freddy@pwpr.com', first_name: 'freddy', last_name: 'Smith', password: 'my_password'
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'Your account has not been approved by your administrator yet.'
        end
      end
    end
    context 'when SchemeOperator does NOT have the director role' do
      let(:scheme_operator_with_sc_user) { FactoryGirl.create(:scheme_operator_with_sc_user) }

      before do
        sign_in scheme_operator_with_sc_user
      end

      after do
        sign_out scheme_operator_with_sc_user
      end

      context 'when calling new' do
        it 'expects a CanCan AccessDenied error to be raised' do
          post :create, email: 'freddy@pwpr.com', first_name: 'freddy', last_name: 'Smith', password: 'my_password'
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end

    context 'when SchemeOperator has sc_director role' do
      let(:scheme_operator_with_director) { FactoryGirl.create(:scheme_operator_with_director) }
      before do
        sign_out scheme_operator_with_director
        scheme_operator_with_director.add_role :sc_director
        scheme_operator_with_director.sc_users_w!
        scheme_operator_with_director.co_users_w!
        scheme_operator_with_director.save
        sign_in scheme_operator_with_director
      end

      after do
        scheme_operator_with_director.remove_role :sc_director
        scheme_operator_with_director.remove_role :sc_users_w
        sign_out scheme_operator_with_director
      end

      context 'when calling create' do
        it 'expects a SchemeOperator to be created' do
          post :create, scheme_operator: {email:                  'freddy@pwpr.com',
                                          first_name:             'freddy',
                                          last_name:              'Smith',
                                          password:               'my_password',
                                          invitation_sent_at:     DateTime.now,
                                          confirmed_at:           DateTime.now,
                                          invitation_accepted_at: DateTime.now,
                                          approved:               true}
          expect(response.status).to eq 302
          so_user = SchemeOperator.find_by_email('freddy@pwpr.com')
          expect(so_user).to be_a(SchemeOperator)
          expect(so_user.first_name).to eq 'freddy'
        end
      end

      context 'when calling create' do
        it 'expects a SchemeOperator to be created' do
          post :create, scheme_operator: {email:        'confirmed@pwpr.com',
                                          first_name:   'confirmed',
                                          last_name:    'Smith',
                                          password:     'my_password',
                                          confirmed_at: DateTime.now}
          expect(response.status).to eq 302
          so_user = SchemeOperator.find_by_email('confirmed@pwpr.com')
          expect(so_user).to be_a(SchemeOperator)
          expect(so_user.first_name).to eq 'confirmed'
        end
      end
    end
  end
  context 'when an Admin is signed in' do
    let(:admin) { FactoryGirl.create(:super_admin) }
    before do
      sign_in admin
    end

    after do
      sign_out admin
    end

    context 'when calling new' do
      it 'expects a scheme operator to be created' do
        get :new
        expect(response.status).to eq 200
      end
    end

    context 'when calling create' do
      it 'expects a 200 response status' do
        post :create, scheme_operator: {email: 'freddy@pwpr.com', first_name: 'freddy', last_name: 'Smith', password: 'my_password'}
        expect(response.status).to eq 302
      end
    end
  end
end

RSpec.describe CompanyOperators::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:company_operator]
  end

  context 'when scheme operator is NOT signed in' do
    context 'when calling create' do
      it 'expects to be redirected to sign in' do
        post :create, params: {}
        expect(response.status).to eq 302
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end
  end

  context 'when scheme operator is signed in' do
    let(:scheme_operator_with_sc_user) { FactoryGirl.create(:scheme_operator_with_sc_user) }

    context 'when SchemeOperator does NOT have the director role' do
      before do
        sign_in scheme_operator_with_sc_user
      end

      after do
        sign_out scheme_operator_with_sc_user
      end

      context 'when calling new' do
        it 'expects a CanCan AccessDenied error to be raised' do
          post :create, email: 'freddy@pwpr.com', first_name: 'freddy', last_name: 'Smith', password: 'my_password', business: Business.last
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end

    context 'when SchemeOperator has co_director role' do
      let(:scheme_operator_with_director) { FactoryGirl.create(:scheme_operator_with_director) }
      before do
        sign_in scheme_operator_with_director
      end

      after do
        sign_out scheme_operator_with_director
      end

      context 'when calling create' do
        it 'expects a CompanyOperator to be created' do
          post :create, company_operator: {email:                  'freddy1@pwpr.com',
                                           first_name:             'freddy',
                                           last_name:              'Kruger',
                                           password:               'my_password',
                                           invitation_sent_at:     DateTime.now,
                                           confirmed_at:           DateTime.now,
                                           invitation_accepted_at: DateTime.now,
                                           approved:               true,
                                           business_id:            Business.last.id}
          expect(response.status).to eq 302
          so_user = CompanyOperator.find_by_email('freddy1@pwpr.com')
          expect(so_user).to be_a(CompanyOperator)
          expect(so_user.first_name).to eq 'freddy'
        end
      end

      context 'when calling create' do
        it 'expects a SchemeOperator to be created' do
          post :create, company_operator: {email:        'confirmed@pwpr.com',
                                           first_name:   'confirmed',
                                           last_name:    'Kruger',
                                           password:     'my_password',
                                           business_id:  Business.last.id,
                                           confirmed_at: DateTime.now}
          expect(response.status).to eq 302
          so_user = CompanyOperator.find_by_email('confirmed@pwpr.com')
          expect(so_user).to be_a(CompanyOperator)
          expect(so_user.first_name).to eq 'confirmed'
        end
      end
    end
  end
  context 'when an Admin is signed in' do
    let(:admin) { FactoryGirl.create(:super_admin) }
    before do
      sign_in admin
    end

    after do
      sign_out admin
    end

    context 'when calling new' do
      it 'expects a company operator to be created' do
        get :new
        expect(response.status).to eq 200
      end
    end

    context 'when calling create' do
      it 'expects a 200 response status' do
        post :create, company_operator: {email:       'freddy@pwpr.com',
                                         first_name:  'freddy',
                                         last_name:   'Smith',
                                         password:    'my_password',
                                         business_id: Business.last.id}
        expect(response.status).to eq 302
      end
    end
  end
end
