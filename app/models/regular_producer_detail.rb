class RegularProducerDetail < ActiveRecord::Base
  belongs_to :registration

  has_many :material_totals, dependent: :destroy
  has_many :material_details, dependent: :destroy
  has_many :target_totals, dependent: :destroy

  validates_presence_of :registration_id

  def form_fields
    {
      calculation_method_supplier_data:                     {
                                                              field_type: 'boolean'
                                                            },
      calculation_method_sample_weighing:                   {
                                                              field_type: 'boolean'
                                                            },
      calculation_method_sales_records:                     {
                                                              field_type: 'boolean'
                                                            },
      calculation_method_trade_association_method_details:  {
                                                              field_type: 'text',
                                                              required: false
                                                            },
      other_method_details:                                 {
                                                              field_type: 'text',
                                                              required: false
                                                            },
      data_system_used:                                     {
                                                              field_type: 'text',
                                                              required: false
                                                            }
    }
  end
end
