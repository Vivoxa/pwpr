shared_examples 'NOT an admin manager' do
  it 'expects NOT to be able to manage Admins' do
    expect(ability).not_to be_able_to(:manage, Admin.new)
  end
end
