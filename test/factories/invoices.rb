# == Schema Information
#
# Table name: invoices
#
#  id            :bigint           not null, primary key
#  aasm_state    :string
#  amount        :float
#  code          :string
#  currency      :string           default("dollar")
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

FactoryBot.define do
  factory :invoice do
  end
end
