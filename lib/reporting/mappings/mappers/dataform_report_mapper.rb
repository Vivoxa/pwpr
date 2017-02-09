module Reporting
  module Mappings
    module Mappers
      class DataformReportMapper < BaseMapper
        DATAFORM_REPORT_YAML_PATH = '../maps/dataform_report.yml'.freeze

        def load_maps
          load_mappings(DATAFORM_REPORT_YAML_PATH)
        end
      end
    end
  end
end