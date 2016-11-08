shared_examples 'a field with placeholder text' do |url, field, text|
  if url
    it "expects #{field} field to have placeholder text" do
      visit url
      expect(find_field(field)['placeholder']).to eq text
    end
  end
end

