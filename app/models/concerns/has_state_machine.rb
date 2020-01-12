module HasStateMachine
  extend ActiveSupport::Concern

  def next_event
    aasm.events(permitted: true).first.name.to_s
  end

  def next_state
    aasm.states(permitted: true).first.name.to_s
  end

  class_methods do
    def with_status(status)
      where(aasm_state: status)
    end
  end
end
