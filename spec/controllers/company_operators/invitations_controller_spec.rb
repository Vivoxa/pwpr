RSpec.describe CompanyOperators::InvitationsController, type: :controller do
  context 'scheme operator' do
    let(:valid_attributes) do
      {password:    'my_password',
       email:       'star@star.com',
       first_name:  'star',
       last_name:   'gazer',
       business_id: 1}
    end
    before do
      @request.env['devise.mapping'] = Devise.mappings[:company_operator]
    end

    context 'when scheme operator is NOT signed in' do
      context 'when calling create' do
        it 'expects to be redirected to sign in' do
          get :new
          expect(response.status).to eq 302
          expect(response.body).to include('company_operators/sign_in')
        end
      end
    end

    context 'when scheme operator is signed in' do
      let(:co_marti) { SchemeOperator.new }
      before do
        co_marti.email = 'jennifer@back_to_the_future.com'
        co_marti.first_name = 'Jennifer'
        co_marti.last_name = 'Smith'
        co_marti.password = 'mypassword'
        co_marti.confirmed_at = DateTime.now
        co_marti.schemes = [Scheme.create(name: 'test scheme', active: true, scheme_country_code_id: 1)]
        co_marti.approved = true
        co_marti.save
      end
      context 'when SchemeOperator does NOT have the director role' do
        before do
          co_marti.role_list.each do |role|
            co_marti.remove_role role
          end
          sign_in co_marti
        end

        context 'when calling new' do
          it 'expects a CanCan AccessDenied error to be raised' do
            get :new
            expect(flash[:alert]).to be_present
            expect(flash[:alert]).to eq 'You are not authorized to access this page.'
          end
        end
      end

      context 'when SchemeOperator has co_director role' do
        before do
          sign_out co_marti
          co_marti.role_list.each do |role|
            co_marti.remove_role role
          end
          co_marti.add_role :sc_director
          co_marti.add_role :co_users_w

          co_marti.save
          sign_in co_marti
        end

        after do
          sign_out co_marti
        end

        context 'when calling create' do
          context 'with correct params' do
            it 'expects a 200 response status' do
              params = {company_operator: valid_attributes}
              post :create, params
              expect(response.status).to eq 302
              user = CompanyOperator.find_by_email('star@star.com')
              expect(user).to be_a(CompanyOperator)
            end
          end

          context 'with scheme_id missing' do
            it 'expects validation to fail' do
              expect(subject).to receive(:populate_schemes_and_businesses)
              params = {company_operator: {password: 'my_password', email: 'star@star.com', first_name: 'star', last_name: 'gazer', business_id: nil}}
              post :create, params
              expect(assigns(:company_operator).errors.messages[:business]).to include("can't be blank")
            end
          end
        end

        context 'when calling new' do
          it 'expects a new invitation to be created' do
            get :new
            expect(response.status).to eq 200
          end
        end
      end
    end
  end

  context 'when Admin Operator' do
    let(:valid_attributes) do
      {password:    'my_password',
       email:       'star@star.com',
       first_name:  'star',
       last_name:   'gazer',
       business_id: 1}
    end
    context 'when Admin has super_admin role' do
      let(:super_admin) { FactoryGirl.create(:super_admin) }
      before do
        @request.env['devise.mapping'] = Devise.mappings[:company_operator]
        super_admin
        sign_in super_admin
      end

      after do
        sign_out super_admin
      end

      context '#update_businesses' do
        it 'expects something' do
          xhr :get, :update_businesses, scheme_id: 1, format: :js
        end
      end

      context 'when calling create' do
        it 'expects a 302 response status' do
          params = {company_operator: valid_attributes}
          post :create, params
          expect(response.status).to eq 302

          user = CompanyOperator.find_by_email('star@star.com')
          expect(user).to be_a(CompanyOperator)
        end
      end

      context 'when calling new' do
        it 'expects a new invitation to be created' do
          get :new
          expect(response.status).to eq 200
        end
      end
    end
  end

  context 'when Company Operator' do
    let(:valid_attributes) do
      {password:    'my_password',
       email:       'star@star.com',
       first_name:  'star',
       last_name:   'gazer',
       business_id: 1}
    end
    context 'when Company has super_admin role' do
      let(:co) { FactoryGirl.create(:company_operator) }
      before do
        @request.env['devise.mapping'] = Devise.mappings[:company_operator]
        co.co_director!
        # TODO: these will have to be tweaked when role are finished
        co.co_users_w!
        sign_in co
      end

      after do
        sign_out co
      end

      context '#update_businesses' do
        it 'expects something' do
          xhr :get, :update_businesses, scheme_id: 1, format: :js
        end
      end

      context 'when calling create' do
        it 'expects a 302 response status' do
          params = {company_operator: {password:    'my_password',
                                       email:       'star222@star.com',
                                       first_name:  'star',
                                       last_name:   'gazer',
                                       business_id: 1}}
          post :create, params
          expect(response.status).to eq 302

          user = CompanyOperator.find_by_email('star222@star.com')
          expect(user).to be_a(CompanyOperator)
        end
      end

      context 'when calling new' do
        it 'expects a new invitation to be created' do
          get :new
          expect(response.status).to eq 200
        end
      end
    end
  end
end
