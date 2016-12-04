class RegularProducerDetail < ActiveRecord::Base
  belong_to :registration

  has_many :material_totals
  has_many :material_data
  has_many :target_totals
end
