module Api
  module Charts
    class Contract
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      # rubocop:disable Metrics/AbcSize
      def days_spent_data
        staff = {name: 'Staff time', data: {}}
        aggregate = {name: 'Aggregate', data: {}}
        projected = {name: 'Projected', data: {}}
        agg = 0.0
        start_date = @contract.start_date.beginning_of_month
        while start_date <= @contract.end_date.beginning_of_month
          display_date = start_date.strftime('%B %Y')

          report = @contract.full_reports
            .select('reporting_period_id, reporting_period_name, sum(days) AS days, report_estimated')
            .group(:reporting_period_id, :reporting_period_name, :report_estimated)
            .where(full_reports: {reporting_period_date: start_date}).first
          if report
            if report.report_estimated
              projected[:data][display_date] = report.days&.round(2)
            else
              staff[:data][display_date] = report.days&.round(2)
            end
            agg += report.days
            aggregate[:data][display_date] = agg.round(2)
          end
          start_date = start_date.advance(months: 1)
        end
        [staff, aggregate, projected]
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      def contract_burn_data
        staff = {name: 'Staff Costs', data: {}}
        non_staff = {name: 'Non Staff Costs', data: {}}
        aggregate = {name: 'Aggregate', data: {}}
        projected = {name: 'Projected', data: {}}
        budget = {name: 'Budget', data: {}, points: false}
        income = {name: 'Calculated Income', data: {}}
        @agg = 0.0
        start_date = @contract.start_date.beginning_of_month
        while start_date <= @contract.end_date.beginning_of_month
          display_date = start_date.strftime('%B %Y')
          budget[:data][display_date] = @contract.budget&.to_f
          income[:data][display_date] = @contract.linear_income

          report = @contract.full_reports
            .select('reporting_period_id, reporting_period_name, sum(cost) AS cost, report_estimated')
            .group(:reporting_period_id, :reporting_period_name, :report_estimated)
            .where(full_reports: {reporting_period_date: start_date}).first

          fill_counters_for(display_date, report, staff, non_staff, aggregate, projected) if report

          start_date = start_date.advance(months: 1)
        end
        data = [staff, projected, aggregate, budget]
        data << non_staff if non_staff[:data].present?
        data << income if income[:data].present?
        data
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/ParameterLists
      def fill_counters_for(display_date, report, staff, non_staff, aggregate, projected)
        nstaff_cost = @contract.non_staff_costs
          .where(reporting_period_id: report.reporting_period_id)
          .pluck('sum(cost)').first
        if nstaff_cost
          non_staff[:data][display_date] = nstaff_cost
          @agg += nstaff_cost
        end
        if report.report_estimated?
          projected[:data][display_date] = report.cost&.round(2)
        else
          staff[:data][display_date] = report.cost&.round(2)
        end
        @agg += report.cost if report.cost
        aggregate[:data][display_date] = @agg.round(2)
      end
      # rubocop:enable Metrics/ParameterLists
    end
  end
end
