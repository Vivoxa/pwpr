shared_examples 'a registration manager' do
  it 'expects to be able to manage Registrations' do
    expect(ability).to be_able_to(:manage, DeviseOverrides::RegistrationsController.new)
  end
end
