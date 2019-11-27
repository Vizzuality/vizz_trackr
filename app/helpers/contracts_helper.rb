module ContractsHelper
  def event_color(state)
    case state
      when 'restart'
        'btn-primary'
      when 'finish'
        'btn-warning'
      when 'start'
        'btn-success'
      else
        'btn-success'
    end
  end
end
