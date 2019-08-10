class ContractsController < ApplicationController
  def index
    @contracts = Contract.joins(:project).
      order("projects.name ASC, contracts.name ASC")
  end
end
