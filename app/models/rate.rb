# == Schema Information
#
# Table name: rates
#
#  id         :bigint           not null, primary key
#  code       :string
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rates_on_code  (code) UNIQUE
#

class Rate < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :code, uniqueness: true

  def display
    "#{code} [€#{value}]"
  end
end
