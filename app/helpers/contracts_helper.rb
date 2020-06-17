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

    klass = if result <= 100.0
                   'text-primary'
                 else
                   'text-danger'
                 end
    content_tag(:span, result, class: klass)
  end

  def colored_burn burn, income
    klass = if income && burn > income
              'text-danger'
            elsif burn && burn > 0.0
              'text-success'
            end

    content_tag(:span, number_to_currency(burn), class: klass)
  end

  def progress_bar progress, burn = nil
    klass = if burn.nil?
              'primary'
            elsif burn > progress
              'danger'
            else
              'success'
            end
    val = burn ? burn : progress
    progress_bar_for_table val, klass
  end
end
