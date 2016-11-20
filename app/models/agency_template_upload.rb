class AgencyTemplateUpload < ActiveRecord::Base
  include CommonHelpers::LogHelper

  belongs_to :scheme

  VALID_YEARS_FOR_UPLOAD = [2010, 2011, 2012, 2013, 2014, 2015].freeze

  validates_presence_of :scheme_id
  validates_presence_of :year
  validates_presence_of :uploaded_at
  validates_presence_of :uploaded_by_id
  validates_presence_of :uploaded_by_type
  validates_presence_of :filename

  validates_inclusion_of :year, in: VALID_YEARS_FOR_UPLOAD

  def initialize(attributes = {})
    logger.tagged('AgencyTemplateUpload(M)') do
      super
      self.filename = attributes[:filename].original_filename if attributes[:filename]
      self.uploaded_at = DateTime.now
      self.status = CommonHelpers::AgencyTemplateUploadStatus::PENDING
      logger.info "initialize() setting attribute values. Filename #{filename}"
    end
  end
end
