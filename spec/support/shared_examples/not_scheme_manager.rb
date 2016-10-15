shared_examples 'NOT a scheme manager' do
  it 'expects NOT to be able to manage Schemes' do
    expect(ability).not_to be_able_to(:manage, Scheme.new)
  end
end
