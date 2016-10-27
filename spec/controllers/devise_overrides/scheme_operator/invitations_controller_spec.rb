RSpec.describe DeviseOverrides::SchemeOperator::InvitationsController, type: :controller do
  context 'scheme operator' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:scheme_operator]
    end

    context 'when scheme operator is NOT signed in' do
      context 'when calling create' do
        it 'expects to be redirected to sign in' do
          get :new
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
            get :new
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
            params = {scheme_operator: {password: 'my_password', email: 'star@star.com', name: 'star', scheme_ids: [1]}}
            post :create, params
            expect(response.status).to eq 302
            user = SchemeOperator.find_by_email('star@star.com')
            expect(user).to be_a(SchemeOperator)
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
    context 'when Admin has full_access role' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:scheme_operator]
        admin = Admin.create(email: 'freddy@kruger.com', password: 'my password')
        admin.super_admin!
        sign_in admin
      end

      context 'when calling create' do
        it 'expects a 302 response status' do
          params = {scheme_operator: {invitation_sent_at: DateTime.now, password: 'my_password', email: 'star@star.com', name: 'star', scheme_ids: [1]}}
          post :create, params
          expect(response.status).to eq 302
          user = SchemeOperator.find_by_email('star@star.com')
          expect(user).to be_a(SchemeOperator)
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
