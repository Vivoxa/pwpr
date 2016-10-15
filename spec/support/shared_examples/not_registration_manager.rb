shared_examples 'NOT a registration manager' do
  it 'expects NOT to be able to manage Registrations' do
    expect(ability).not_to be_able_to(:manage, DeviseOverrides::RegistrationsController.new)
  end
end
