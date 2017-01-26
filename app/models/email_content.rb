class EmailContent < ActiveRecord::Base
  belongs_to :email_content_type
  belongs_to :email_name

  validates_presence_of :email_content_type, :email_name
end
