class AgencyTemplateUpload < ActiveRecord::Base
  belongs_to :scheme

  validates_presence_of :scheme_id
  validates_presence_of :year
  validates_presence_of :uploaded_at
  validates_presence_of :uploaded_by_id
  validates_presence_of :uploaded_by_type
  validates_presence_of :filename

  def initialize(attributes = {})
    super
    self.year = attributes[:year].to_i
    self.filename = attributes[:filename]
    self.scheme_id = attributes[:scheme_id]
    self.uploaded_by_type = attributes[:uploaded_by_type]
    self.uploaded_by_id = attributes[:uploaded_by_id]
    self.uploaded_at = DateTime.now
    self.status = CommonHelpers::AgencyTemplateUploadStatus::PENDING
  end
end
