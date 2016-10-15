shared_examples 'a writer' do |object|
  it "expects to be able to create a new #{object}" do
    expect(ability).to be_able_to(:new, object)
    expect(ability).to be_able_to(:create, object)
  end
end
