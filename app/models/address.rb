class Address < ActiveRecord::Base
  belongs_to :business
  belongs_to :address_type

  has_many :contacts_addresses
  has_many :contacts, through: :contacts_addresses

  validates_presence_of :business_id, :address_type_id, :address_line_1, :post_code
end
