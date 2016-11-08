shared_examples 'a button' do |url, button_text|
  if url
    it "expects a button to be present with text #{button_text}" do
      visit 'company_operators/sign_in'
      expect(find_button(button_text)).not_to be_nil
    end
  end
end

