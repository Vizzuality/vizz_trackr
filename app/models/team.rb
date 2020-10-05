# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_name  (name) UNIQUE
#

class Team < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :full_reports # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :reports, dependent: :nullify

  validates :name, uniqueness: true
end
