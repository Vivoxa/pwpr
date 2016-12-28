class AgencyTemplateUpload < ActiveRecord::Base
  include CommonHelpers::LogHelper

  belongs_to :scheme

  has_one :registration, dependent: :destroy
  has_many :joiners, dependent: :destroy
  has_many :leavers, dependent: :destroy
  has_many :licensors, dependent: :destroy
  has_many :subsidiaries, dependent: :destroy

  VALID_YEARS_FOR_UPLOAD = [2010, 2011, 2012, 2013, 2014, 2015].freeze

  validates_presence_of :scheme_id, :year, :uploaded_at, :uploaded_by_id, :uploaded_by_type, :filename

  validates_inclusion_of :year, in: VALID_YEARS_FOR_UPLOAD

  validate :record_valid_for_year?

  def record_valid_for_year?
    AgencyTemplateUpload.where(scheme_id: scheme_id, year: year).empty?
  end

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
