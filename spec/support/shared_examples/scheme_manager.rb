shared_examples 'a scheme manager' do
  it 'expects to be able to manage Schemes' do
    expect(ability).to be_able_to(:manage, Scheme.new)
  end
end
