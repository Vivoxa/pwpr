class AnnualTargetSet < ActiveRecord::Base
  belongs_to :scheme_country_code

  has_many :material_targets
  has_many :targets
end
