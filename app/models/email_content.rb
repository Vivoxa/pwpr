class EmailContent < ActiveRecord::Base
  belongs_to :email_content_type
  belongs_to :email_name

  validates_presence_of :email_content_type, :email_name

  scope :pro_scheme, -> (scheme,email_name) {
    where(email_content_type_id: EmailContentType.id_from_setting('scheme'),
          email_name_id: EmailName.id_from_setting(email_name),
          scheme_id: scheme.id)
  }

  scope :default, -> (email_name) {
    where(email_content_type_id: EmailContentType.id_from_setting('default'),
          email_name_id: EmailName.id_from_setting(email_name))
  }

  def self.for_scheme(scheme,email_name)
    h = pro_scheme(scheme,email_name)
    h = default(email_name) if h.empty?
    h.first
  end

  def body_lines
    body.split(/\r\n/)
  end

  def address_lines
    address.split(/\r\n/)
  end
end
