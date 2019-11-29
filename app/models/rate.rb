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

class Rate < ApplicationRecord
  def display
    "#{code} [€#{value}]"
  end
end
