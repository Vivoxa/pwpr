shared_examples 'a destroyer' do |object|
  it "expects to be able to destroy #{object}s" do
    expect(ability).to be_able_to(:destroy, object)
  end
end
