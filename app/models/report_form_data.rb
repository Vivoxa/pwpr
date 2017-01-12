class ReportFormData
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :business_id, :business_name, :email, :email_contact_present, :emailed_report

  def persisted?
    true
  end

  def email_contact_present?
    email_contact_present.present?
  end
end
