class AnnualTargetSet < ActiveRecord::Base
  belongs_to :scheme_country_code

  has_many :material_targets
  has_many :targets

  validates_presence_of :scheme_country_code_id, :value, :year
end
