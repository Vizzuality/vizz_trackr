module Api
  module Charts
    class User
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def reports_breakdown reporting_period_id
        data = []
        reports = @user.full_reports
        reports = reports.where(reporting_period: reporting_period_id) if reporting_period_id
        reports.each do |report|
          entry = data.select { |t| t[:name] == report.contract_name }.first
          unless entry
            entry = {name: report.contract_name}
            new_entry = true
          end
          entry[:data] = {} unless entry[:data]
          entry[:data][report.reporting_period_name] = report.percentage
          data << entry if new_entry
        end
        data
      end
    end
  end
end
