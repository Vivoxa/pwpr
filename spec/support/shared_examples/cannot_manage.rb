shared_examples 'NOT a manager' do |object|
  it "expects NOT to be able to manage #{object}" do
    expect(ability).not_to be_able_to(:manager, object)
  end
end
