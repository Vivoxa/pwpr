class RegularProducerDetail < ActiveRecord::Base
  belongs_to :registration

  has_many :material_totals, dependent: :delete_all
  has_many :material_details, dependent: :delete_all
  has_many :target_totals, dependent: :delete_all

  validates_presence_of :registration_id
end
