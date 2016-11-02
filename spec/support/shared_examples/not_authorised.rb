shared_examples 'a NOT authorised user' do |verb, action, params|
  it 'expects to be redirected and a CanCan AccessDenied raised' do
    case verb
    when 'get'
      get action, params
    when 'put'
      put action, params
    end
    expect(flash[:alert]).to be_present
    expect(flash[:alert]).to eq 'You are not authorized to access this page.'
  end
end
