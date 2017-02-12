class SchemeOperatorsScheme < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :scheme_operator

  validates_presence_of :scheme_operator_id
end
