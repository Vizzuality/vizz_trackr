# == Schema Information
#
# Table name: contracts
#
#  id         :bigint           not null, primary key
#  name       :string
#  project_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  budget     :float
#  alias      :string           default([]), is an Array
#  start_date :date
#  end_date   :date
#

class Contract < ApplicationRecord
  belongs_to :project
  has_many :report_parts, dependent: :destroy
  has_many :full_reports

  validates_uniqueness_of :name

  def alias_list
    self.alias.join(", ")
  end

  def alias_list= list
    self.alias = list.split(",").map(&:strip).uniq.sort
  end

  def full_name
    "#{name} [#{project.name}]"
  end
end
