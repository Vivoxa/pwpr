class ReportFormData
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :business_id, :business_name, :email, :email_contact_present, :date_last_sent

  def persisted?
    true
  end

  def email_contact_present?
    email_contact_present
  end
end
