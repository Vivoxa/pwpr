[SchemeOperators::RegistrationsController, CompanyOperators::RegistrationsController].each do |registration_controller|
  RSpec.describe registration_controller, type: :controller do
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
      let(:co_marti) { SchemeOperator.new }
      before do
        co_marti.email = 'jennifer@back_to_the_future.com'
        co_marti.name = 'Jennifer'
        co_marti.password = 'mypassword'
        co_marti.confirmed_at = DateTime.now
        co_marti.schemes = [Scheme.create(name: 'test scheme', active: true)]
        co_marti.save
      end
      context 'when SchemeOperator does NOT have the director role' do
        before do
          sign_in co_marti
        end

        context 'when calling new' do
          it 'expects a CanCan AccessDenied error to be raised' do
            post :create, email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', schemes: [Scheme.last]
            expect(flash[:alert]).to be_present
            expect(flash[:alert]).to eq 'You are not authorized to access this page.'
          end
        end
      end

      context 'when SchemeOperator has co_director role' do
        before do
          sign_out co_marti
          co_marti.add_role('sc_director')
          co_marti.save
          sign_in co_marti
        end

        context 'when calling create' do
          it 'expects a 200 response status' do
            post :create, scheme_operator: {email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', scheme_ids: [Scheme.last]}
            expect(response.status).to eq 302
            so_user = SchemeOperator.find_by_email('freddy@pwpr.com')
            expect(so_user).to be_a(SchemeOperator)
            expect(so_user.name).to eq 'freddy'
          end
        end
      end
    end
    context 'when an Admin is signed in' do
      let(:admin) { Admin.new }
      before do
        admin.email = 'the_boss@back_to_the_future.com'
        admin.name = 'BOSS'
        admin.password = 'mypassword'
        admin.save
        admin.full_access!
      end
      before do
        sign_in admin
      end

      context 'when calling new' do
        it 'expects a scheme operator to be created' do
          get :new
          expect(response.status).to eq 200
        end
      end

      context 'when calling new' do
        it 'expects a 200 response status' do
          post :create, email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', schemes: [Scheme.last]
          expect(response.status).to eq 200
        end
      end
    end
  end
end
