# == Schema Information
#
# Table name: contracts
#
#  id         :bigint           not null, primary key
#  name       :string
#  project_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  budget     :float
#  alias      :string           default([]), is an Array
#  start_date :date
#  end_date   :date
#

class Contract < ApplicationRecord
  include AASM

  aasm do
    state :proposal, initial: true
    state :live
    state :finished
    event :start do
      transitions from: :proposal, to: :live
    end
    event :finish do
      transitions from: :live, to: :finished
    end
    event :restart do
      transitions from: :finished, to: :live
    end
  end

  belongs_to :project
  has_many :report_parts, dependent: :destroy
  has_many :full_reports

  validates_uniqueness_of :name
  delegate :is_billable?, to: :project

  def alias_list
    self.alias.join(', ')
  end

  def alias_list= list
    self.alias = list.split(',').map(&:strip).uniq.sort
  end

  def full_name
    "#{name} [#{project.name}]"
  end

  def next_event
    self.aasm.events(permitted: true).first.name.to_s
  end
  def next_state
    self.aasm.states(permitted: true).first.name.to_s
  end
  def self.with_status(status)
    where(aasm_state: status )
  end
end
