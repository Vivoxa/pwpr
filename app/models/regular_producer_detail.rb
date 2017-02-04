class RegularProducerDetail < ActiveRecord::Base
  belongs_to :registration

  has_many :material_totals, dependent: :destroy
  has_many :material_details, dependent: :destroy
  has_many :target_totals, dependent: :destroy

  validates_presence_of :registration_id

  def form_fields
    [
      :calculation_method_supplier_data,
      :calculation_method_or_other_method_used,
      :calculation_method_sample_weighing,
      :calculation_method_sales_records,
      :calculation_method_trade_association_method_details,
      :consultant_system_used,
      :other_method_details,
      :data_system_used
    ]
  end
end
