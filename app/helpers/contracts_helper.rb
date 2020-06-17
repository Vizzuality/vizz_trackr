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
    content_tag :div, class: 'widget-content p-0' do
      content_tag :div, class: 'widget-content-outer' do
        content_tag :div, class: 'widget-content-wrapper' do
          content_tag :div, class: 'widget-content-left pr-2 text-right', style: 'width: 80px;' do
            content_tag(:div, "#{val&.round(2)}%", class: "text-#{klass}")
          end.concat(
          content_tag(:div, class: 'widget-content-right w-100') do
            content_tag(:div, class: 'progress-bar-xs progress') do
              content_tag(:div, nil, class: "progress-bar bg-#{klass}", role: 'progressbar', 'aria-valuenow': val,
                'aria-valuemin': 0, 'aria-valuemax': 100, style: "width: #{val}%")
            end
          end)
        end
      end
    end
  end
end
