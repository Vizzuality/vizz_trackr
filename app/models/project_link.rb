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

class ProjectLink < ApplicationRecord
  belongs_to :project
  LINK_TYPES = %w[code project-management app-environments design].freeze

  enum link_type: array_to_enum_hash(LINK_TYPES)
end
