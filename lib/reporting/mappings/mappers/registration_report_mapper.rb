module Reporting
  module Mappings
    module Mappers
      class RegistrationReportMapper

        def load_maps
          maps = YAML.load_file(File.join(__dir__, '../maps/registration_report.yml'))
          binding.pry
        end
      end
    end
  end
end