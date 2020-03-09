module ApplicationHelper
  def billable_tag element
    klass = element.is_billable? ? 'warning' : 'info'
    text = element.is_billable? ? 'Billable' : 'Non-billable'
    content_tag(:span, class: "badge badge-#{klass}") do
      text
    end
  end

  def td_for_burn burn, progress = 0
    klass = if burn <= progress
              'success'
            elsif burn > progress && burn <= 100
              'warning'
            elsif burn > 100
              'danger'
            else
              ''
            end
    content_tag :td, class: "text-#{klass}" do
      burn ? "#{burn}%" : '-'
    end
  end
end
