module Api
  module Charts
    class Contract
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def contract_burn_data
        agg = 0.0
        contract = {name: 'Burn', data: {}}
        aggregate = {name: 'Aggregate', data: {}}
        projected = {name: 'Projected', data: {}}
        budget = {name: 'Budget', data: {}, points: false}
        @contract.full_reports
          .select('reporting_period_name, sum(cost) AS cost, report_estimated')
          .group(:reporting_period_name, :report_estimated)
          .order(Arel.sql("TO_DATE(reporting_period_name, 'MonthYYYY') ASC")).each do |report|
          if report.report_estimated?
            projected[:data][report.reporting_period_name] = report.cost
          else
            contract[:data][report.reporting_period_name] = report.cost
          end
          agg += report.cost
          aggregate[:data][report.reporting_period_name] = agg
          budget[:data][report.reporting_period_name] = @contract.budget&.to_f
        end
        [contract, projected, aggregate, budget]
      end
    end
  end
end
