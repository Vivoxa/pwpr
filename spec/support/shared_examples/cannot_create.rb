shared_examples 'NOT a writer' do |object|
  it "expects NOT to be able to create a new #{object}" do
    expect(ability).not_to be_able_to(:new, object)
    expect(ability).not_to be_able_to(:create, object)
  end
end
