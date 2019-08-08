class Contract < ApplicationRecord
  belongs_to :project

  def alias_list
    self.alias.join(", ")
  end

  def alias_list= list
    self.alias = list.split(",").map(&:strip).uniq.sort
  end
end
