shared_examples 'a business manager' do
  it 'expects to be able to manage Businesses' do
    expect(ability).to be_able_to(:manage, Business.new)
  end
end
