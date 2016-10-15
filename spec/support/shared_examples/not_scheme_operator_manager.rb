shared_examples 'NOT a scheme operator manager' do
  it 'expects NOT to be able to manage SchemeOperators' do
    expect(ability).not_to be_able_to(:manage, SchemeOperator.new)
  end
end
