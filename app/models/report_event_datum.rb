class ReportEventDatum < ActiveRecord::Base

  DELIM = ','.freeze

  def get_business_ids
    business_ids.split(DELIM).map(&:to_i)
  end
end
