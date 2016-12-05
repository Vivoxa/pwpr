class ContactsAddress < ActiveRecord::Base
  belongs_to :address
  belongs_to :contact
end
