module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class LeaversHandler < BaseHandler
        def initialize(agency_template_id)
          super
        end

        def process
          leavers.drop(3).each do |row_array|
            next if empty_row?(row_array)
            
            @leaver = Leaver.new
            @business = get_business(row_array, column_value(row_array, map['npwd']['field']))

            process_leaver(row_array)
          end
        end

        private

        def process_leaver(row)
          @leaver.total_recovery_previous = column_value(row, map['total_recovery']['field']).to_f
          @leaver.leaving_date = Date.parse(column_value(row, map['date_left']['field']).to_s)
          @leaver.leaving_code = LeavingCode.where(code: column_value(row, map['leaving_reason']['field'])).first
          @leaver.scheme_comments = column_value(row, map['scheme_comments']['field'])
          @leaver.business = @business
          @leaver.leaving_business = create_leaving_business(row) unless @business
          @leaver.agency_template_upload = @agency_template
          @leaver.save!
        end

        def leavers
          spreadsheet.sheet(6)
        end

        def map
          map_loader.load(:leavers)
        end
      end
    end
  end
end
