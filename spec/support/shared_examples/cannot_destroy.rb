shared_examples 'NOT a destroyer' do |object|
  it "expects NOT to be able to destroy #{object}s" do
    expect(ability).not_to be_able_to(:destroy, object)
  end
end
