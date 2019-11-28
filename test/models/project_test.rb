# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#  is_billable :boolean          default(TRUE)
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
