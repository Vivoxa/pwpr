module Reporting
  module Mappings
    module Mappers
      class RegistrationReportMapper
        REGISTRATION_REPORT_YAML_PATH = '../maps/registration_report.yml'.freeze

        def load_maps
          YAML.load_file(File.join(__dir__, REGISTRATION_REPORT_YAML_PATH))
        end
      end
    end
  end
end
