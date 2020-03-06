module ApplicationHelper
  def billable_tag element
    klass = element.is_billable? ? 'warning' : 'info'
    text = element.is_billable? ? 'Billable' : 'Non-billable'
    content_tag(:span, class: "badge badge-#{klass}") do
      text
    end
  end

  def td_for_burn budget, costs
    burn = budget && budget > 0.0 ? (costs / budget * 100).round(2) : nil
    klass = if burn
              (burn <= 100 ? 'success' : 'danger')
            else
              ''
            end
    content_tag :td, class: "text-#{klass}" do
      burn ? "#{burn}%" : '-'
    end
  end
end
