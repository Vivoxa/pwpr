class ReportEventDatum < ActiveRecord::Base
  DELIM = ','.freeze

  def retrieve_business_ids
    business_ids.split(DELIM).map(&:to_i)
  end
end
