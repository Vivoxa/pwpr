module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class SubleaversHandler < BaseHandler
        def initialize(agency_template_id)
          super
        end

        def process
          # @sheet_filename = './public/template_sheet.xls'

          subleavers.drop(3).each do |row_array|
            @subleaver = Leaver.new
            @business = get_business(row_array, column_value(row_array, map['npwd']['field']))

            process_subleaver(row_array)
          end
        end

        private

        def process_subleaver(row)
          return if empty_row?(row)
          @subleaver.leaving_date = Date.parse(column_value(row, map['date_left']['field']).to_s)
          @subleaver.leaving_code = LeavingCode.where(code: column_value(row, map['leaving_reason']['field'])).first
          @subleaver.sub_leaver = true
          @subleaver.scheme_comments = column_value(row, map['scheme_comments']['field'])
          @subleaver.business = @business
          @subleaver.leaving_business = create_leaving_business(row) unless @business
          @subleaver.agency_template_upload = @agency_template
          @subleaver.save!
        end

        def subleavers
          spreadsheet.sheet(7)
        end

        def map
          map_loader.load(:subleavers)
        end
      end
    end
  end
end
