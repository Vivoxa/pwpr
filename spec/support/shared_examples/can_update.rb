shared_examples 'an updater' do |object|
  it "expects to be able to update #{object}s" do
    expect(ability).to be_able_to(:update, object)
  end
end
