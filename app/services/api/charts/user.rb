module Api
  module Charts
    class User
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def reports_breakdown reporting_period_id
        reports = if reporting_period_id
                    @user.full_reports.where(reporting_period_id: reporting_period_id)
                  else
                    reporting_period = ::ReportingPeriod.last
                    @user.full_reports.where(reporting_period_id: reporting_period.id)
                  end
        reports.group(:contract_name).sum(:percentage)
      end
    end
  end
end
