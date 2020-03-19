module Api
  module Charts
    class Contract
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end

      def days_spent_data
        staff = {name: 'Staff time', data: {}}
        aggregate = {name: 'Aggregate', data: {}}
        projected = {name: 'Projected', data: {}}
        agg = 0.0
        dates.each do |date|
          next unless report_for date

          if @report.report_estimated
            projected[:data][date] = @report.days&.round(2)
          else
            staff[:data][date] = @report.days&.round(2)
          end
          agg += @report.days
          aggregate[:data][date] = agg.round(2)
        end
        [staff, aggregate, projected]
      end

      # rubocop:disable Metrics/AbcSize
      def contract_burn_data
        staff = {name: 'Staff Costs', data: {}}
        non_staff = {name: 'Non Staff Costs', data: {}}
        aggregate = {name: 'Aggregate', data: {}}
        projected = {name: 'Projected', data: {}}
        budget = {name: 'Budget', data: dates.map { |d| [d, @contract.budget&.to_f] }.to_h, points: false}
        income = {name: 'Income', data: {}}
        agg = 0.0
        dates.each do |date|
          income[:data][date] = income_for(date)

          if report_for date
            if @report.report_estimated?
              projected[:data][date] = @report.cost&.round(2)
            else
              staff[:data][date] = @report.cost&.round(2)
            end
            agg += @report.cost
          end

          non_staff[:data][date] = non_staff_costs_for(date)
          agg += non_staff_costs_for(date)
          aggregate[:data][date] = agg.round(2)
        end
        data = [staff, projected, aggregate, budget]
        data << non_staff if non_staff[:data].present?
        data << income if income[:data].present?
        data
      end
      # rubocop:enable Metrics/AbcSize

      private

      def dates
        start ||= [@contract.start_date, @contract.full_reports.minimum(:reporting_period_date)].compact.min
        end_date ||= [@contract.end_date, @contract.full_reports.maximum(:reporting_period_date)].compact.max
        return [] unless start && end_date

        @dates ||= (start..end_date)
          .map { |d| Date.new(d.year, d.month, 1) }
          .uniq
      end

      def report_for(date)
        @report = @contract.full_reports
          .select('reporting_period_id, reporting_period_name, sum(days) AS days, sum(cost) AS cost, report_estimated')
          .group(:reporting_period_id, :reporting_period_name, :report_estimated)
          .where(full_reports: {reporting_period_date: date})
          .where.not(cost: nil).first
      end

      def non_staff_costs_for(date)
        @contract.non_staff_costs
          .joins(:reporting_period)
          .where(reporting_periods: {date: date})
          .pluck('sum(cost)').first || 0.0
      end

      def income_for date
        delta = @contract.progress_reports
          .joins(:reporting_period)
          .where(reporting_periods: {date: date}).first&.delta

        return @contract.budget * delta / 100 if delta

        return nil if @contract.latest_progress_report && @contract.latest_progress_report.date >= date

        @contract.linear_income
      end
    end
  end
end
