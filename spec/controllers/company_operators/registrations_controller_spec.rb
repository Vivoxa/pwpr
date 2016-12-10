RSpec.describe CompanyOperators::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:company_operator]
  end

  context 'when scheme operator is NOT signed in' do
    context 'when calling create' do
      before do
        post :create, params: {}
      end
      it 'expects to be redirected via 302' do
        expect(response.status).to eq 302
      end

      it 'expects to be redirected to sign in' do
        expect(response.body).to include('scheme_operators/sign_in')
      end
    end
  end

  context 'when scheme operator is signed in' do
    let(:co_marti) { SchemeOperator.new }
    before do
      co_marti.email = 'jennifer@back_to_the_future.com'
      co_marti.first_name = 'Jennifer'
      co_marti.password = 'mypassword'
      co_marti.confirmed_at = DateTime.now
      co_marti.schemes = [Scheme.create(name: 'test scheme', active: true, scheme_country_code_id: 1)]
      co_marti.approved = true
      co_marti.save
    end
    context 'when SchemeOperator has not been approved' do
      before do
        co_marti.approved = false
        co_marti.save
        sign_in co_marti
      end

      after do
        co_marti.approved = true
        co_marti.save
        sign_out co_marti
      end

      context 'when calling new' do
        before do
          post :create, email: 'freddy@pwpr.com', first_name: 'freddy', password: 'my_password', business: Business.last
        end
        it 'expects an error to be raised' do
          expect(flash[:alert]).to be_present
        end

        it 'expects an error to be displyed to the user' do
          expect(flash[:alert]).to eq 'Your account has not been approved by your administrator yet.'
        end
      end
    end
    context 'when SchemeOperator does NOT have the director role' do
      before do
        sign_in co_marti
      end

      after do
        sign_out co_marti
      end

      context 'when calling new' do
        before do
          post :create, email: 'freddy@pwpr.com', first_name: 'freddy', password: 'my_password', business: Business.last
        end
        it 'expects a CanCan AccessDenied error to be raised' do
          expect(flash[:alert]).to be_present
        end

        it 'expects a CanCan AccessDenied error to be displayed' do
          expect(flash[:alert]).to eq 'You are not authorized to access this page.'
        end
      end
    end

    context 'when SchemeOperator has co_director role' do
      before do
        sign_out co_marti
        co_marti.add_role :sc_director
        co_marti.sc_users_w!
        co_marti.co_users_w!
        co_marti.save
        sign_in co_marti
      end

      after do
        co_marti.remove_role :sc_director
        co_marti.remove_role :sc_users_w
        co_marti.remove_role :co_users_w
        sign_out co_marti
      end

      context 'when calling create' do
        it 'expects a CompanyOperator to be created' do
          post :create, company_operator: {email:                  'freddy1@pwpr.com',
                                           first_name:             'freddy',
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
      context 'when creating a confirmed user' do
        let(:so_user) { CompanyOperator.find_by_email('confirmed@pwpr.com') }
        before do
          post :create, company_operator: {email:        'confirmed@pwpr.com',
                                           first_name:   'confirmed',
                                           password:     'my_password',
                                           business_id:  Business.last.id,
                                           confirmed_at: DateTime.now}
        end
        context 'when calling create' do
          it 'expects to be redirected with a 302' do
            expect(response.status).to eq 302
          end

          it 'expects a SchemeOperator to be ccreated' do
            expect(so_user).to be_a(CompanyOperator)
          end

          it 'expects a SchemeOperator to be confirmed' do
            expect(so_user.first_name).to eq 'confirmed'
          end
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
        post :create, company_operator: {email: 'freddy@pwpr.com', first_name: 'freddy', password: 'my_password', business_id: Business.last.id}
        expect(response.status).to eq 302
      end
    end
  end
end
