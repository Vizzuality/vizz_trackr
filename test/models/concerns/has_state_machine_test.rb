require 'test_helper'

class DummyClass
  include AASM
  include HasStateMachine
  aasm do
    state :unstarted, initial: true
    state :started
    state :finished

    event :start do
      transitions from: :unstarted, to: :started
    end

    event :finish do
      transitions from: :started, to: :finished
    end
  end
end

class HasStateMachineTest < ActiveSupport::TestCase
  setup do
    @dummy = DummyClass.new
  end

  test '#next_event should be :start for new records' do
    assert_equal 'start', @dummy.next_event
  end

  test '#next_state should be :started for new records' do
    assert_equal 'started', @dummy.next_state
  end

  test '#next_state should be :finished after a record was started' do
    @dummy.start!
    assert_equal 'finished', @dummy.next_state
  end
end

