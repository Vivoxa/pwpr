require 'yaml'

module SpreadsheetWorker
  module SheetMapLoader
    class Map
      def load(sheet)
        map = YAML.load_file(File.join(__dir__, "maps/#{sheet}_map.yml"))
        map[sheet.to_s]
      end
    end
  end
end
