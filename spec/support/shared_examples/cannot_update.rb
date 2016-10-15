shared_examples 'NOT an updater' do |object|
  it "expects NOT to be able to update #{object}s" do
    expect(ability).not_to be_able_to(:update, object)
  end
end
