class ReportFormData
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :business_id, :business_name, :email

  def persisted?
    true
  end
end