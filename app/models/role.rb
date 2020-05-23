# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :full_reports # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :report_parts, dependent: :nullify
  has_many :budget_lines, dependent: :nullify

  validates :name, uniqueness: true
end
