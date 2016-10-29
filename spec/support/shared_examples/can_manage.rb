shared_examples 'a manager' do |object|
  it "expects to be able to manage #{object}" do
    %i(read edit update new create destroy).each do |action|
      expect(ability).to be_able_to(action, object)
    end
  end
end
