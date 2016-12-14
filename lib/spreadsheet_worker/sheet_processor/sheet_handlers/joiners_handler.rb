module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class JoinersHandler < BaseHandler
        def initialize(agency_template_id)
          super
          @joiner = Joiner.new
        end

        def process
          @sheet_filename = './public/template_sheet.xls'
          # row_array = joiners.row(4)

          joiners.drop(3).each do |row_array|
            @business = get_business(row_array, column_value(row_array, map['npwd']['field']))

            process_joiner(row_array)
          end
        end

        private

        def process_joiner(row)
          @joiner.total_recovery = column_value(row, map['total_recovery']['field']).to_f
          @joiner.previously_registered_at = column_value(row, map['previously_registered_at']['field'])
          @joiner.joining_date = Date.parse(column_value(row, map['date_joined']['field']).to_s)
          @joiner.date_scheme_registered = Date.parse(column_value(row, map['date_scheme_registered']['field']).to_s)
          @joiner.business = @business
          @joiner.agency_template_upload = @agency_template
          @joiner.save!
        end

        def joiners
          spreadsheet.sheet(8)
        end

        def map
          map_loader.load(:joiners)
        end
      end
    end
  end
end
