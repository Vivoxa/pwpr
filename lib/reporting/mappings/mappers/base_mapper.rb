module Reporting
  module Mappings
    module Mappers
      class BaseMapper

        def load_mappings(path_to_map)
          YAML.load_file(File.join(__dir__, path_to_map))
        end
      end
    end
  end
end
