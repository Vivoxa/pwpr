class MaterialDetail < ActiveRecord::Base
  belongs_to :regular_producer_detail
  belongs_to :packaging_material

  validates_presence_of :regular_producer_detail_id, :packaging_material_id, :t1man, :t1conv, :t1pf, :t1sell, :t2aman,
                        :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c

  def form_fields
    [
      :t1man,
      :t1conv,
      :t1pf,
      :t1sell,
      :t2aman,
      :t2aconv,
      :t2apf,
      :t2asell,
      :t2bman,
      :t2bconv,
      :t2bpf,
      :t2bsell,
      :t3aconv,
      :t3apf,
      :t3asell,
      :t3b,
      :t3c
    ]
  end
end
