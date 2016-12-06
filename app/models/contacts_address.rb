class ContactsAddress < ActiveRecord::Base
  belongs_to :address
  belongs_to :contact

  validates_presence_of :address_id, :contact_id
end
