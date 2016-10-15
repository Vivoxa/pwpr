shared_examples 'an editor' do |object|
  it "expects to be able to edit #{object}" do
    expect(ability).to be_able_to(:edit, object)
  end
end
