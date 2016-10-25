shared_examples 'a manager' do |object|
  it "expects to be able to manage #{object}" do
    expect(ability).to be_able_to(:manager, object.new)
  end
end
