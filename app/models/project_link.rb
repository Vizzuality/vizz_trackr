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

class ProjectLink < ApplicationRecord
  belongs_to :project
  LINK_TYPES = %w[code project-management app-environments design].freeze

  enum link_type: array_to_enum_hash(LINK_TYPES)
end
