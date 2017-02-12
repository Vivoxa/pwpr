class AgencyTemplateUpload < ActiveRecord::Base
  include CommonHelpers::LogHelper

  belongs_to :scheme

  has_many :registrations, dependent: :destroy
  has_many :joiners, dependent: :destroy
  has_many :leavers, dependent: :destroy
  has_many :licensors, dependent: :destroy
  has_many :subsidiaries, dependent: :destroy

  validates_presence_of :scheme_id, :year, :uploaded_at, :uploaded_by_id, :uploaded_by_type, :filename

  validates_inclusion_of :year, in: LookupValues::ValidYears.for('reports')

  validate :record_valid_for_year?

  scope :for_previous_year, lambda { |scheme_id, current_year|
                            where(scheme_id: scheme_id, year: (current_year.to_i - 1))
                          }

  scope :for_current_year, lambda { |scheme_id, current_year|
                           where(scheme_id: scheme_id, year: (current_year.to_i))
                         }

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
