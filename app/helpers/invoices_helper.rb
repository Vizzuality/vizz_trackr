module InvoicesHelper
  def invoice_event_color(state)
    case state
    when :scheduled
      'info'
    when :pending_to_issue
      'danger'
    when :waiting_for_payment
      'warning'
    when :paid
      'success'
    else
      'info'
    end
  end
end
