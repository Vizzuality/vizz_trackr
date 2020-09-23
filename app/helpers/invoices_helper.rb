module InvoicesHelper
    def invoice_event_color(state)
    case state
    when 'raise'
      'btn-primary'
    when 'issue'
      'btn-primary'
    when 'confirm_payment'
      'btn-success'
    else
      'btn-success'
    end
  end
end
