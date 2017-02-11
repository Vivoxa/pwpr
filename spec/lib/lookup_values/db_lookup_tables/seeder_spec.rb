require 'rails_helper'

RSpec.describe LookupValues::DbLookupTables::Seeder do
  subject(:seeder) { described_class.new }

  before do
    allow(ActiveRecord::Base.connection).to receive(:execute)
  end
  it 'expects valid settings to be returned' do
    expect(seeder).to receive(:get_columns).exactly(16).times
    expect(seeder).to receive(:get_values).exactly(16).times
    seeder.populate_lookup_tables
  end

  it 'expects the tables to be truncated and reseeded' do
    expect(seeder).to receive(:truncate_table).exactly(16).times
    expect(seeder).to receive(:populate_table).exactly(16).times
    seeder.populate_lookup_tables
  end
end
