class Registration < ActiveRecord::Base
  belongs_to :sic_code
  belongs_to :submission_type
  belongs_to :agency_template_upload
  belongs_to :packaging_sector_main_activity
  belongs_to :resubmission_reason
  belongs_to :business

  has_one :small_producer_detail, dependent: :destroy
  has_one :regular_producer_detail, dependent: :destroy

  validates_presence_of :sic_code_id, :packaging_sector_main_activity, :turnover

  # attr_accessible :sic_code, :packaging_sector_main_activity, :submission_type, :resubmission_reason, :turnover,
  #                 :licensor, :allocation_method_used

  def editable?
    business.year_last_reg.to_i <= Date.today.year
  end

  def small_producer?
    allocation_method_used
  end

  def material_totals_set
    return [] if !regular_producer_detail || regular_producer_detail&.material_totals.empty?
    regular_producer_detail&.material_totals.last(7)
  end

  def packaging_materials_set
    return [] if !regular_producer_detail || regular_producer_detail&.material_details.empty?
    regular_producer_detail&.material_details.last(7)
  end

  def year
    business.year_last_reg
  end

  def sic_code_value
    sic_code&.code&.to_s
  end

  def sector_main_activity_value
    packaging_sector_main_activity&.material&.to_s
  end

  def submission_code_value
    submission_type&.code&.to_s
  end

  def resubmission_code_value
    resubmission_reason&.reason&.to_s
  end

  def form_fields
    {
      sic_code:                       {field_type: 'collection',
                                       choices:    SicCode.all,
                                       field:      :code,
                                       required:   false,
                                       value: self.sic_code&.code},
      packaging_sector_main_activity: {field_type: 'collection',
                                       choices:    PackagingSectorMainActivity.all,
                                       field:      :material,
                                       required:   false,
                                       value: self.packaging_sector_main_activity&.material},
      submission_type:                {
        field_type: 'collection',
        choices:    SubmissionType.all,
        field:      :code,
        required:   true,
        value: self.submission_type&.code
      },
      resubmission_reason:            {
        field_type: 'collection',
        choices:    ResubmissionReason.all,
        field:      :reason,
        required:   true,
        value: self.resubmission_reason&.reason
      },
      turnover:                       {
        field_type: 'number',
        required:   true
      },
      licensor:                       {field_type: 'boolean'},
      allocation_method_used:         {field_type: 'boolean'}
    }
  end
end
