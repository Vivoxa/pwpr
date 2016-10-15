shared_examples 'NOT a company operator manager' do
  it 'expects NOT to be able to manage CompanyOperators' do
    expect(ability).not_to be_able_to(:manage, CompanyOperator.new)
  end
end
