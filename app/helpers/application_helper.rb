module ApplicationHelper
  def billable_tag element
    klass = element.is_billable? ? "warning" : "info"
    text = element.is_billable? ? "Billable" : "Non-billable"
    content_tag(:span, class: "badge badge-#{klass}") do
      text
    end
  end

  def progress_bar_for_table val, klass
    content_tag :div, class: "widget-content p-0" do
      content_tag :div, class: "widget-content-outer" do
        content_tag :div, class: "widget-content-wrapper" do
          content_tag :div, class: "widget-content-left pr-2 text-right", style: "width: 80px;" do
            content_tag(:div, "#{val&.round(2)}%", class: "text-#{klass}")
          end.concat(
            content_tag(:div, class: "widget-content-right w-100") do
              content_tag(:div, class: "progress-bar-xs progress") do
                content_tag(:div, nil, class: "progress-bar bg-#{klass}", role: "progressbar", "aria-valuenow": val,
                  "aria-valuemin": 0, "aria-valuemax": 100, style: "width: #{val}%")
              end
            end
          )
        end
      end
    end
  end
end
