module Api
  module Charts
    class ReportingPeriod
      attr_reader :reporting_periods_scope

      def initialize(reporting_periods_scope)
        @reporting_periods_scope = reporting_periods_scope
      end

      def reporting_periods_burn_data
        billable_burn = {name: 'Billable', data: {}}
        billable_projection = {name: 'Billable Projection', data: {}}
        non_billable_burn = {name: 'Non Billable', data: {}}
        non_billable_projection = {name: 'Non Billable Projection', data: {}}
        @reporting_periods_scope.each do |rp|
          billable_burn[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: true, report_estimated: false).sum(:cost).round(2)
          billable_projection[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: true, report_estimated: true).sum(:cost).round(2)
          non_billable_burn[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: false).sum(:cost).round(2)
          non_billable_burn[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: false, report_estimated: false).sum(:cost).round(2)
          non_billable_projection[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: false, report_estimated: true).sum(:cost).round(2)
        end
        [billable_burn, billable_projection,
         non_billable_burn, non_billable_projection]
      end
    end
  end
end
