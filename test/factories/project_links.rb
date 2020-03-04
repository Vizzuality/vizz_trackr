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

FactoryBot.define do
  factory :project_link do
    project { nil }
    title { 'MyString' }
    url { 'MyString' }
  end
end
