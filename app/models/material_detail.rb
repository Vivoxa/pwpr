class MaterialDetail < ActiveRecord::Base
  belongs_to :regular_producer_detail
  belongs_to :packaging_material

  validates_presence_of :regular_producer_detail_id, :packaging_material_id, :t1man, :t1conv, :t1pf, :t1sell, :t2aman,
                        :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell,
                        :t3b, :t3c

  def form_fields
    {
      t1man:    {
                  field_type: 'number',
                    required: true
                },
      t1conv:   {
                  field_type: 'number',
                  required: true
                },
      t1pf:     {
                  field_type: 'number',
                  required: true
                },
      t1sell:   {
                  field_type: 'number',
                  required: true
                },
      t2aman:   {
                  field_type: 'number',
                  required: true
                },
      t2aconv:  {
                  field_type: 'number',
                  required: true
                },
      t2apf:    {
                  field_type: 'number',
                  required: true
                },
      t2asell:  {
                  field_type: 'number',
                  required: true
                },
      t2bman:   {
                  field_type: 'number',
                  required: true
                },
      t2bconv:  {
                  field_type: 'number',
                  required: true
                },
      t2bpf:    {
                  field_type: 'number',
                  required: true
                },
      t2bsell:  {
                  field_type: 'number',
                  required: true
                },
      t3aconv:  {
                  field_type: 'number',
                  required: true
                },
      t3apf:    {
                  field_type: 'number',
                  required: true
                },
      t3asell:  {
                  field_type: 'number',
                  required: true
                },
      t3b:      {
                  field_type: 'number',
                  required: true
                },
      t3c:      {
                  field_type: 'number',
                  required: true
                }
    }
  end
end
