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

FactoryBot.define do
  factory :project_link do
    project { nil }
    title { 'MyString' }
    url { 'MyString' }
  end
end
