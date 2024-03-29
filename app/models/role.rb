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

class Role < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :full_reports
  has_many :report_parts, dependent: :nullify
  has_many :budget_lines, dependent: :nullify

  validates :name, uniqueness: true
end
