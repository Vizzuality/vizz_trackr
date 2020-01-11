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
  has_many :full_reports
  has_many :reports, dependent: :nullify

  validates_uniqueness_of :name
end
