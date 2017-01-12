require 'rails_helper'

RSpec.describe LookupValues::FormLookups do
  it 'expects valid settings to be returned' do
    form_lookups = described_class.for('salutations')

    expect(form_lookups).to eq %w(Mr Mrs Miss Ms Dr)
  end
end
