module ContractsHelper
  def contract_event_color(state)
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

    class_name = if result <= 100.0
                   'text-primary'
                 else
                   'text-danger'
                 end
    content_tag(:span, result, class: class_name)
  end

  def td_for_burn burn, progress = 0
    return content_tag(:td) unless burn

    klass = if burn <= progress
              'success'
            elsif burn > progress
              'danger'
            else
              ''
            end
    content_tag :td, class: "text-#{klass}" do
      burn ? "#{burn}%" : '-'
    end
  end
end
