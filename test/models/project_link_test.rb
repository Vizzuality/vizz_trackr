# == Schema Information
#
# Table name: project_links
#
#  id         :bigint           not null, primary key
#  project_id :bigint           not null
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  link_type  :string
#

require 'test_helper'

class ProjectLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
