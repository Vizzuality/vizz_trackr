# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_name  (name) UNIQUE
#

require "test_helper"

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
