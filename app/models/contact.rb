class Contact < ActiveRecord::Base
  belongs_to :business

  has_many :contacts_addresses
  has_many :addresses, through: :contacts_addresses

  validates_presence_of :business_id, :title, :first_name, :last_name, :email, :telephone_1
end
