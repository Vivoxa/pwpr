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
    self.filename = attributes[:filename].original_filename if attributes[:filename]
    self.uploaded_at = DateTime.now
    self.status = CommonHelpers::AgencyTemplateUploadStatus::PENDING
  end
end
