module Reporting
  module Mappings
    module Mappers
      class RegistrationReportMapper < BaseMapper
        REGISTRATION_REPORT_YAML_PATH = '../maps/registration_report.yml'.freeze

        def load_maps
          load_mappings(REGISTRATION_REPORT_YAML_PATH)
        end
      end
    end
  end
end
