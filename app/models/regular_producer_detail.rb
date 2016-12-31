class RegularProducerDetail < ActiveRecord::Base
  belongs_to :registration

  has_many :material_totals, dependent: :destroy
  has_many :material_details, dependent: :destroy
  has_many :target_totals, dependent: :destroy

  validates_presence_of :registration_id
end
