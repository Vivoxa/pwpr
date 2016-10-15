shared_examples 'NOT an editor' do |object|
  it "expects NOT to be able to edit #{object}" do
    expect(ability).not_to be_able_to(:edit, object)
  end
end
