class RegularProducerDetail < ActiveRecord::Base
  belongs_to :registration
  belongs_to :data_system
  belongs_to :trade_association_method

  has_many :material_totals, dependent: :destroy
  has_many :material_details, dependent: :destroy
  has_many :target_totals, dependent: :destroy

  validates_presence_of :registration_id

  def form_fields
    {
      calculation_method_supplier_data:                    {
        field_type: 'boolean'
      },
      calculation_method_sample_weighing:                  {
        field_type: 'boolean'
      },
      calculation_method_sales_records:                    {
        field_type: 'boolean'
      },
      trade_association_method:                    {
        field_type: 'collection',
        choices:    TradeAssociationMethod.all,
        field:      :method,
        required:   false,
        value: self.trade_association_method&.name
      },
      data_system:                                    {
        field_type: 'collection',
        choices:    DataSystem.all,
        field:      :system,
        required:   false,
        value: self.data_system&.name
      },
      other_method_details:                                {
        field_type: 'text',
        required:   false
      }
    }
  end
end
