shared_examples 'a scheme operator manager' do
  it 'expects to be able to manage SchemeOperators' do
    expect(ability).to be_able_to(:manage, SchemeOperator.new)
  end
end
