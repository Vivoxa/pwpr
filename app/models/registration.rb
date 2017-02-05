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

  def form_fields
    {
      sic_code:                       { field_type: 'collection',
                                        choices: SicCode.all,
                                        field: :code,
                                        required: false
                                      },
      packaging_sector_main_activity: { field_type: 'collection',
                                        choices: PackagingSectorMainActivity.all,
                                        field: :material,
                                        required: false
                                      },
      submission_type:                {
                                        field_type: 'collection',
                                        choices: SubmissionType.all,
                                        field: :code,
                                        required: true
                                      },
      resubmission_reason:            {
                                        field_type: 'collection',
                                        choices: ResubmissionReason.all,
                                        field: :reason,
                                        required: true
                                      },
      turnover:                        {
                                        field_type: 'number',
                                        required: true
                                      },
      licensor:                       { field_type: 'boolean' },
      allocation_method_used:         { field_type: 'boolean' }
    }
  end
end
