# == Schema Information
#
# Table name: project_links
#
#  id         :bigint           not null, primary key
#  link_type  :string
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_project_links_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

require "test_helper"

class ProjectLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
