RSpec.describe SchemeOperators::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:scheme_operator]
  end

  context 'when scheme operator is NOT signed in' do
    context 'when calling create' do
      it 'expects status to be 302' do
        post :create, params: {}
        expect(response.status).to eq 302
      end

      it 'expects to be redirected to sign in' do
        post :create, params: {}
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
      co_marti.approved = true
      co_marti.save
    end
    context 'when SchemeOperator has not been approved' do
      before do
        co_marti.approved = false
        co_marti.sc_users_w!
        co_marti.co_users_w!
        co_marti.save
        sign_in co_marti
      end

      after do
        co_marti.approved = true
        co_marti.remove_role :sc_users_w
        co_marti.remove_role :co_users_w
        co_marti.save
        sign_out co_marti
      end

      context 'when calling new' do
        it 'expects an alert message to be flashed to the user' do
          post :create, email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', schemes: [Scheme.last]
          expect(flash[:alert]).to be_present
        end

        it 'expects the message to tell the user they are not approved yet' do
          post :create, email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', schemes: [Scheme.last]
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
        it 'expects an alert message to be flashed to the user' do
          post :create, email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', schemes: [Scheme.last]
          expect(flash[:alert]).to be_present
        end

        it 'expects the message to alert that not authorised' do
          post :create, email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', schemes: [Scheme.last]
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
        sign_out co_marti
      end

      context 'when calling create' do
        let(:so_user) { SchemeOperator.find_by_email('freddy@pwpr.com') }
        before do
          post :create, scheme_operator: {email:                  'freddy@pwpr.com',
                                          name:                   'freddy',
                                          password:               'my_password',
                                          invitation_sent_at:     DateTime.now,
                                          confirmed_at:           DateTime.now,
                                          invitation_accepted_at: DateTime.now,
                                          approved:               true,
                                          scheme_ids:             [Scheme.last]}
        end

        it 'expects to be redirected with A 302' do
          expect(response.status).to eq 302
        end

        it 'expects a SchemeOperator to be created' do
          expect(so_user).to be_a(SchemeOperator)
        end

        it 'expects the newly created user to have the correct name' do
          expect(so_user.name).to eq 'freddy'
        end
      end
      context 'when creating a confirmed user' do
        let(:so_user) { SchemeOperator.find_by_email('confirmed@pwpr.com') }
        context 'when calling create' do
          before do
            post :create, scheme_operator: {email:        'confirmed@pwpr.com',
                                            name:         'confirmed',
                                            password:     'my_password',
                                            scheme_ids:   [Scheme.last.id],
                                            confirmed_at: DateTime.now}
          end
          it 'expects a SchemeOperator to be created' do
            expect(so_user).to be_a(SchemeOperator)
          end
          it 'expects to be redirected with  302' do
            expect(response.status).to eq 302
          end
          it 'expects the newly created user to have the correct name' do
            expect(so_user.name).to eq 'confirmed'
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
      it 'expects a scheme operator to be created' do
        get :new
        expect(response.status).to eq 200
      end
    end

    context 'when calling create' do
      it 'expects a 200 response status' do
        post :create, scheme_operator: {email: 'freddy@pwpr.com', name: 'freddy', password: 'my_password', scheme_ids: [Scheme.last.id]}
        expect(response.status).to eq 302
      end
    end

    context 'when the scheme operator creation fails' do
      context 'when calling create' do
        it 'expects cleanup to be performed' do
          expect_any_instance_of(DeviseController).to receive(:clean_up_passwords)
          expect_any_instance_of(DeviseController).to receive(:set_minimum_password_length)
          post :create, scheme_operator: {email:        'confirmed@pwpr.com',
                                          name:         'confirmed',
                                          password:     'my_password',
                                          confirmed_at: DateTime.now}
        end
      end
    end
  end
end