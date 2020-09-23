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

  paginates_per 40

  include AASM
  include HasStateMachine

  aasm do
    state :scheduled, initial: true, display: 'Scheduled'
    state :pending_to_issue, display: 'Pending to issue'
    state :waiting_for_payment, display: 'Waiting for payment'
    state :paid, display: 'Paid'
    event :raise do
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

  belongs_to :contract

  def must_issue?
    due_date <= Date.today && aasm.current_state == :pending_to_issue
  end

  def self.search query
    return all unless query

    joins(:contract)
      .where('contract_id = ? ', "#{query}")
  end

  
end
