shared_examples 'a NOT signed in user' do |verb, action, params|
  it 'expects to be redirected to sign in' do
    case verb
    when 'get'
      get action, params
    end
    expect(response.status).to eq 302
    expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
  end
end
