module Api
  module Charts
    class ReportingPeriod
      attr_reader :reporting_periods_scope

      def initialize(reporting_periods_scope)
        @reporting_periods_scope = reporting_periods_scope
      end

      def reporting_periods_cost_data
        billable_time = {name: 'Billable Staff Costs', data: {}}
        non_staff_costs = {name: 'Billable External Costs', data: {}}
        billable_projection = {name: 'Billable Projection', data: {}}
        income = {name: 'Income (live contracs)', data: {}}
        @reporting_periods_scope.each do |rp|
          billable_time[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: true, report_estimated: false).sum(:cost).round(2)
          billable_projection[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: true, report_estimated: true).sum(:cost).round(2)
          income[:data][rp.display_name] = MonthlyIncome
            .where(month: rp.date, aasm_state: 'live').first&.income.round(2)
          non_staff_costs[:data][rp.display_name] = rp
            .non_staff_costs.sum(:cost).round(2)
        end
        [billable_time, income, non_staff_costs, billable_projection]
      end
    end
  end
end
