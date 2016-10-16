shared_examples 'NOT a business manager' do
  it 'expects NOT to be able to manage Businesses' do
    expect(ability).not_to be_able_to(:manage, Business.new)
  end
end
