class AgencyTemplateUpload < ActiveRecord::Base
  belongs_to :scheme

  validates_presence_of :scheme_id
  validates_presence_of :year
  validates_presence_of :uploaded_at
  validates_presence_of :uploaded_by_id
  validates_presence_of :uploaded_by_type
end
