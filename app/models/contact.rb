class Contact < ActiveRecord::Base
  belongs_to :business

  has_many :contacts_addresses
  has_many :addresses, through: :contacts_addresses
end
