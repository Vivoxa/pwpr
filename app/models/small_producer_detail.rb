class SmallProducerDetail < ActiveRecord::Base
  belongs_to :registration
  belongs_to :subsidiary

  validates_presence_of :allocation_method_predominant_material, :allocation_method_obligation, :registration_id

  def predominant_material_value
    allocation_method_predominant_material&.capitalize
  end

  def form_fields
    {
      allocation_method_predominant_material: {
        field_type: 'collection',
        choices:    PackagingMaterial.all - excluded_materials,
        field:      :name,
        required:   true,
        value:      allocation_method_predominant_material&.name
      },
      allocation_method_obligation:           {
        field_type: 'number',
        required:   true
      }
    }
  end

  private

  def excluded_materials
    ['glassremelt']
  end
end
