shared_examples 'a reader' do |object|
  it "expects to be able to read #{object}" do
    expect(ability).to be_able_to(:read, object)
  end
end
