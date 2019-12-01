module Api
  module Charts
    class Contract
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def contract_burn_data
        agg = 0.0
        contract = {name: 'Staff Costs', data: {}}
        non_staff = {name: 'Non Staff Costs', data: {}}
        aggregate = {name: 'Aggregate', data: {}}
        projected = {name: 'Projected', data: {}}
        budget = {name: 'Budget', data: {}, points: false}
        income = {name: 'Calculated Income', data: {}}
        linear_income = @contract.linear_income
        @contract.full_reports
          .select('reporting_period_id, reporting_period_name, sum(cost) AS cost, report_estimated')
          .group(:reporting_period_id, :reporting_period_name, :report_estimated)
          .order(Arel.sql("TO_DATE(reporting_period_name, 'MonthYYYY') ASC")).each do |report|
          nstaff_cost = @contract.non_staff_costs
            .where(reporting_period_id: report.reporting_period_id).pluck('sum(cost)').first
          if nstaff_cost
            non_staff[:data][report.reporting_period_name] = nstaff_cost
            agg += nstaff_cost
          end
          if report.report_estimated?
            projected[:data][report.reporting_period_name] = report.cost
          else
            contract[:data][report.reporting_period_name] = report.cost
          end
          agg += report.cost if report.cost
          aggregate[:data][report.reporting_period_name] = agg
          budget[:data][report.reporting_period_name] = @contract.budget&.to_f
          income[:data][report.reporting_period_name] = linear_income
        end
        data = [contract, projected, aggregate, budget]
        data << non_staff if non_staff[:data].present?
        data << income if income[:data].present?
        data
      end
    end
  end
end
