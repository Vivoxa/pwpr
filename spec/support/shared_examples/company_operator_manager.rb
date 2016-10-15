shared_examples 'a company operator manager' do
  it 'expects to be able to manage CompanyOperators' do
    expect(ability).to be_able_to(:manage, CompanyOperator.new)
  end
end
