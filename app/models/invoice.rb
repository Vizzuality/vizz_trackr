# == Schema Information
#
# Table name: invoices
#
#  id            :bigint           not null, primary key
#  aasm_state    :string
#  amount        :float
#  code          :string
#  due_date      :date
#  extended_date :date
#  invoiced_on   :date
#  milestone     :text
#  observations  :text
#  contract_id   :bigint
#
# Indexes
#
#  index_invoices_on_contract_id  (contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#

class Invoice < ApplicationRecord

  belongs_to :contract

  paginates_per 40

  include AASM
  include HasStateMachine

  aasm do
    state :scheduled, initial: true, display: 'Scheduled'
    state :pending_to_issue, display: 'Pending to issue'
    state :waiting_for_payment, display: 'Waiting for payment'
    state :paid, display: 'Paid'
    event :raise_alert do
      transitions from: :scheduled, to: :pending_to_issue
    end
    event :issue do
      transitions from: :pending_to_issue, to: :waiting_for_payment
    end
    event :confirm_payment do
      transitions from: :waiting_for_payment, to: :paid
    end
  end

  validates :due_date, presence: true
  validates :milestone, presence: true
  validates :amount, presence: true, numericality: {only_float: true}
  validates :code, presence: true, if: Proc.new { |invoice| invoice.aasm.current_state == :waiting_for_payment || invoice.aasm.current_state == :paid }
  validates :invoiced_on, presence: true, if: Proc.new { |invoice| invoice.aasm.current_state == :waiting_for_payment || invoice.aasm.current_state == :paid }
  validate :extended_date_is_possible?

  def extended_date_is_possible?
    return if extended_date.blank?
    if due_date > extended_date
      errors.add(:extended_date, 'must be after due date')
    end
  end

  def announcement
    msg = <<-EOS
      Hello!
      There is an invoice from #{contract} pending to issue. Please go to https://vizz-trackr.herokuapp.com/invoices/#{id} to do it.
      Thank you!
    EOS
    {
      channel: Rails.env.production? ? '#invoices' : '#vizz-tracker',
      text: msg,
      icon_emoji: ':vizzuality:',
      parse: 'full'
    }.to_json
  end


  def must_issue?
    due_date <= Date.today && aasm.current_state == :pending_to_issue
  end

  def self.search query
    return all unless query

    joins(:contract)
      .where('contract_id = ? ', "#{query}")
  end

  
end
