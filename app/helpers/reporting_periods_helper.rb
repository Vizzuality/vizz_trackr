module ReportingPeriodsHelper
    def event_color(state)
    case state
      when 'reactivate'
        'btn-primary'
      when 'terminate'
        'btn-warning'
      when 'activate'
        'btn-success'
      else
        'btn-success'
    end
  end
end
