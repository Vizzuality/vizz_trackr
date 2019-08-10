class Contract < ApplicationRecord
  belongs_to :project
  has_many :report_parts, dependent: :destroy

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
