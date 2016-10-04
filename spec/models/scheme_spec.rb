require 'rails_helper'

RSpec.describe Scheme, type: :model do

  context 'Roles' do
    it 'expects the correct roles to be available' do
      expect(Scheme.available_role_names).to eq %w(owner admin user_r user_rw)
    end

    it 'expects owner to be an available role' do
      expect(subject.allowed_role? :owner).to be true
    end

    it 'expects admin to be an available role' do
      expect(subject.allowed_role? :admin).to be true
    end

    it 'expects user_r to be an available role' do
      expect(subject.allowed_role? :user_r).to be true
    end

    it 'expects user_rw to be an available role' do
      expect(subject.allowed_role? :user_rw).to be true
    end

    it 'expects name to be an attribute' do
      expect(subject.respond_to?(:name)).to be true
    end
  end
end
