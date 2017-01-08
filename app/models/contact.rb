class Contact < ActiveRecord::Base
  belongs_to :business
  belongs_to :address_type
  has_many :contacts_addresses
  has_many :addresses, through: :contacts_addresses

  validates_presence_of :business_id, :first_name, :last_name, :telephone_1, :address_type_id

  scope :active, -> { where(active: true) }
end
