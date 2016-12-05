class Address < ActiveRecord::Base
  belongs_to :business
  belongs_to :address_type

  has_many :contacts_addresses
  has_many :contacts, through: :contacts_addresses
end
