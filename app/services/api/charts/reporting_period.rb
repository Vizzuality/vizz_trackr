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
        income = {name: 'Income', data: {}}
        @reporting_periods_scope.each do |rp|
          billable_burn[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: true, report_estimated: false).sum(:cost).round(2)
          billable_projection[:data][rp.display_name] = rp.full_reports
            .where(project_is_billable: true, report_estimated: true).sum(:cost).round(2)
          income[:data][rp.display_name] = MonthlyIncome
            .where(month: rp.date, aasm_state: 'live').first&.income.round(2)
        end
        [billable_burn, billable_projection, income]
      end
    end
  end
end
