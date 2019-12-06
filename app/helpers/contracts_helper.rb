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

  def result_with_color(result)
    return '?' unless result
    class_name = if result >= 30
                   'text-primary'
                 elsif result >= 20
                   'text-warning'
                 else
                   'text-danger'
                 end
    content_tag(:span, result, class: class_name)
  end
end
