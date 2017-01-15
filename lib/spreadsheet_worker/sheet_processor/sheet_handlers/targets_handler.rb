module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class TargetsHandler < BaseHandler
        def initialize(agency_template_id)
          super
        end

        def process
          targets.drop(3).each do |row_array|
            next if empty_row?(row_array)

            @target = Target.new
            @business = get_business(row_array, column_value(row_array, map['npwd']['field']))
            break unless @business

            materials.each do |material|
              process_material_details(row_array, material) unless material == 'glassremelt'
              process_material_totals(row_array, material) unless material == 'other'
            end

            process_target_totals(row_array)
          end
        end

        private

        def process_material_details(row, mat)
          material = MaterialDetail.new
          material.regular_producer_detail = @business.registrations.last.regular_producer_detail
          material.packaging_material = PackagingMaterial.where(name: mat).first

          material.t1man = column_value(row, map['t1man'][mat]['field']).to_f
          material.t1conv = column_value(row, map['t1conv'][mat]['field']).to_f
          material.t1pf = column_value(row, map['t1pf'][mat]['field']).to_f
          material.t1sell = column_value(row, map['t1sell'][mat]['field']).to_f
          material.t2aman = column_value(row, map['t2aman'][mat]['field']).to_f
          material.t2aconv = column_value(row, map['t2aconv'][mat]['field']).to_f
          material.t2apf = column_value(row, map['t2apf'][mat]['field']).to_f
          material.t2asell = column_value(row, map['t2asell'][mat]['field']).to_f
          material.t2bman = column_value(row, map['t2bman'][mat]['field']).to_f
          material.t2bconv = column_value(row, map['t2bconv'][mat]['field']).to_f
          material.t2bpf = column_value(row, map['t2bpf'][mat]['field']).to_f
          material.t2bsell = column_value(row, map['t2bsell'][mat]['field']).to_f
          material.t3aconv = column_value(row, map['t3aconv'][mat]['field']).to_f
          material.t3apf = column_value(row, map['t3apf'][mat]['field']).to_f
          material.t3asell = column_value(row, map['t3asell'][mat]['field']).to_f
          material.t3b = column_value(row, map['t3b'][mat]['field']).to_f
          material.t3c = column_value(row, map['t3c'][mat]['field']).to_f
          material.save!
        end

        def process_material_totals(row, mat)
          material_total = MaterialTotal.new
          material_total.regular_producer_detail = @business.registrations.last.regular_producer_detail
          material_total.packaging_material = PackagingMaterial.where(name: mat).first
          material_total.recycling_obligation = column_value(row, map['obligation'][mat]['field']).to_f
          material_total.save!
        end

        def process_target_totals(row)
          target_total = TargetTotal.new
          target_total.regular_producer_detail = @business.registrations.last.regular_producer_detail
          target_total.total_recycling_obligation = column_value(row, map['total_obligation']['recycling']['field']).to_f
          target_total.total_recovery_obligation = column_value(row, map['total_obligation']['recovery']['field']).to_f
          target_total.total_material_specific_recycling_obligation = column_value(row, map['total_obligation']['material_specific']['field']).to_f
          target_total.adjusted_total_recovery_obligation = column_value(row, map['total_obligation']['adjusted_recovery']['field']).to_f
          target_total.ninetytwo_percent_min_recycling_target = column_value(row, map['total_obligation']['nintytwo_min']['field']).to_f
          target_total.save!
        end

        def targets
          spreadsheet.sheet(5)
        end

        def map
          map_loader.load(:targets)
        end

        def materials
          %w(paper glass aluminium steel plastic wood glassremelt other)
        end
      end
    end
  end
end
