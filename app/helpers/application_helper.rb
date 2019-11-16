module ApplicationHelper
  def billable_tag element
    klass = element.is_billable? ? 'warning' : 'info'
    text = element.is_billable? ? 'Billable' : 'Non-billable'
    content_tag(:span, class: "badge badge-#{klass}") do
      text
    end
  end
end
