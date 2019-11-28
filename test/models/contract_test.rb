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
#  aasm_state :string
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
