module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class SubleaversHandler < BaseHandler
        def initialize(agency_template_id)
          super
          @subleaver = Leaver.new
        end

        def process
          @sheet_filename = './public/template_sheet.xls'
          # row_array = subleavers.row(4)

          subleavers.drop(2).each do |row_array|
            @business = get_business(row_array)

            process_subleaver(row_array)
          end
        end

        private

        def process_subleaver(row)
          @subleaver.leaving_date = Date.parse(column_value(row, map['date_left']['field']).to_s)
          @subleaver.leaving_code = LeavingCode.where(code: column_value(row, map['leaving_reason']['field'])).first
          @subleaver.sub_leaver = true
          @subleaver.business = @business
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
