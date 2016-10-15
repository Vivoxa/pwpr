shared_examples 'an admin manager' do
  it 'expects to be able to manage Admins' do
    expect(ability).to be_able_to(:manage, Admin.new)
  end
end
